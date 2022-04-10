

const currentDate = new Date()

const HOUR = 1;

const nextHour = currentDate.setTime(currentDate.getTime() + (HOUR * 60 * 60 * 1000 ))
const nextDay = (new Date()).setDate(new Date().getDate() + 2)
const nextMin = (new Date()).setTime(new Date().getTime() + (60 * 1000))

export type Product = {
    id: number,
    name: string,
    biddingPrice: number,
    endTime: number
}

export type Bidding = {
    price: number,
    bidder: string,
    dateTime: number
}

export type BiddingProduct = {
    [key: number]: Bidding[]
}

// will end time next hour when start server
export const initialData: Product[] = [
    {
        id: 0,
        name: 'Iphone 8 64 Model:ZA/A สีขาว ประกันศูนย์ 6/11/2022',
        biddingPrice: 1000,
        endTime: nextHour
    },
    {
        id: 1,
        name: 'Iphone X 64 Model:ZA/A สีขาว ประกันศูนย์ 6/11/2022',
        biddingPrice: 1000,
        endTime: nextHour
    },
    {
        id: 2,
        name: 'Iphone XS 64 Model:ZA/A สีขาว ประกันศูนย์ 6/11/2022',
        biddingPrice: 1000,
        endTime: nextHour
    },
    {
        id: 3,
        name: 'Iphone XR 64 Model:ZA/A สีขาว ประกันศูนย์ 6/11/2022',
        biddingPrice: 1000,
        endTime: nextMin
    },
    {
        id: 4,
        name: 'Iphone 11 64 Model:ZA/A สีขาว ประกันศูนย์ 6/11/2022',
        biddingPrice: 1000,
        endTime: nextHour
    },
    {
        id: 5,
        name: 'Iphone 12 64 Model:ZA/A สีขาว ประกันศูนย์ 6/11/2022',
        biddingPrice: 1000,
        endTime: nextDay
    }
]

const _mockBidding1: Bidding[] = [
    {
        price: 1000,
        bidder: 'test1',
        dateTime: currentDate.setTime(currentDate.getTime() - ( 60 * 60 * 1000 ))  // 60 minutes Ago
    },
    {
        price: 2000,
        bidder: 'test2',
        dateTime: currentDate.setTime(currentDate.getTime() - (50 * 60 * 1000 )) // 50 minutes Ago
    },
    {
        price: 3000,
        bidder: 'test3',
        dateTime: currentDate.setTime(currentDate.getTime() - (40 * 60 * 1000 )) // 40 minutes Ago
    },
    {
        price: 4000,
        bidder: 'test4',
        dateTime: currentDate.setTime(currentDate.getTime() - (30 * 60 * 1000 )) // 30 minutes Ago
    },
    {
        price: 5000,
        bidder: 'test5',
        dateTime: currentDate.setTime(currentDate.getTime() - (20 * 60 * 1000 )) // 20 minutes Ago
    },
    {
        price: 6000,
        bidder: 'test6',
        dateTime: currentDate.setTime(currentDate.getTime() - (10 * 60 * 1000 )) // 10 minutes Ago
    }
]

export const biddingInitial: BiddingProduct = {
    0: _mockBidding1,
}