import * as express from 'express'
import * as http from 'http'
import * as WebSocket from 'ws'
import { Application, Request, Response } from 'express'
import { initialData, biddingInitial, Product, BiddingProduct, Bidding } from './data'
import * as _ from 'lodash'
import * as bodyParser from 'body-parser'


const app = express();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(bodyParser.raw());


const biddingHistory: BiddingProduct  = biddingInitial

let productData: Product[] = priceMapper(initialData, biddingInitial)


//initialize a simple http server
const server = http.createServer(app);

//initialize the WebSocket server instance
const wss = new WebSocket.Server({ server });

interface ExtWebSocket extends WebSocket {
    isAlive: boolean;
}

function createMessage(content: string, isBroadcast = false, sender = 'NS'): string {
    return JSON.stringify(new Message(content, isBroadcast, sender));
}

function priceMapper(products: Product[], history: BiddingProduct) {

    const mapperProduct :Product[] = products.map((d: Product) => {
        const biddingHistoryById: Bidding[] = history[d.id]
        if (!biddingHistoryById) {
            return d
        }
        const max = _.maxBy(biddingHistoryById, 'price')
        const biddingPrice = max!.price
        return { ...d, biddingPrice };
    })

    return mapperProduct;

}

export class Message {
    constructor(
        public content: string,
        public isBroadcast = false,
        public sender: string
    ) { }
}

wss.on('connection', (ws: WebSocket) => {

    const extWs = ws as ExtWebSocket;

    extWs.isAlive = true;

    ws.on('pong', () => {
        extWs.isAlive = true;
    });

    //connection is up, let's add a simple simple event
    ws.on('message', (msg: string) => {

        const message = JSON.parse(msg) as Message;

        setTimeout(() => {
            if (message.isBroadcast) {

                //send back the message to the other clients
                wss.clients
                    .forEach(client => {
                        if (client != ws) {
                            client.send(createMessage(message.content, true, message.sender));
                        }
                    });

            }

            ws.send(createMessage(`You sent -> ${message.content}`, message.isBroadcast));

        }, 1000);

    });

    //send immediatly a feedback to the incoming connection    
    ws.send(createMessage('Hi there, I am a WebSocket server'));

    ws.on('error', (err) => {
        console.warn(`Client disconnected - reason: ${err}`);
    })
});

setInterval(() => {
    wss.clients.forEach((ws: WebSocket) => {

        const extWs = ws as ExtWebSocket;

        if (!extWs.isAlive) return ws.terminate();

        extWs.isAlive = false;
        ws.ping(null, undefined);
    });
}, 10000);

app.get('/', (req: Request, res: Response) => {
    res.status(200).json({ data: productData })
})

app.get('/history/:id', (req: Request, res: Response) => {
    const { id } = req.params
    if (!id) {
        res.status(400).json({ message: 'ID Not Found '})
    } else {
        res.status(200).json({ data: biddingHistory[Number(id)] })
    }
})

app.post('/bidding', (req: Request, res: Response) => {
    try {
        const { body } = req

        const list: Bidding[] = _.get(biddingHistory, body.id, [])
        const price: number = _.get(body, 'price', 0)
        const currentDate = new Date()
        const data: Bidding = {
            price,
            bidder: `${body.bidder}`,
            dateTime: currentDate.getTime()
        }
        
        // if found in history
        if (list.length > 0) {
            const maxPrice = _.maxBy(list, 'price')
            if (maxPrice!.price < price) {
                list.push(data)
                wss.clients.forEach(client => {
                    client.send(JSON.stringify({ id: body.id, ...data }));
                })

                // update DB
                biddingHistory[body.id] = list
                productData = priceMapper(productData, biddingHistory)

                res.status(200).json({ data: { found: true } })
            } else {
                res.status(400).json({ data: { found: true } })
            }
        } else {
            const _product = productData.find((d) => d.id === body.id)
            if (!_product) {
                res.status(400).json({ data: { found: false } })
            } else {
                if (_product.biddingPrice < price) {
                    const data: Bidding = {
                        price,
                        bidder: `${body.bidder}`,
                        dateTime: currentDate.getTime()
                    }
                    list.push(data)
                    wss.clients.forEach(client => {
                        client.send(JSON.stringify({ id: body.id, ...data }));
                    })

                    // update DB
                    biddingHistory[body.id] = list
                    productData = priceMapper(productData, biddingHistory)

                    res.status(200).json({ data: { found: true } })
                } else {
                    res.status(400).json({ data: { found: true } })
                }
            }
        }
        

        res.status(200).json({ data: true })
    } catch(e) {
        
    }
})

//start our server
server.listen(process.env.PORT || 8999, () => {
    console.log(`Server started on port ${server.address().port} :)`);
});