const dbf = require('./query')
const wooapi = require('./woo')
module.exports = function (app, db, woo_api) {

    const categories_list = (array, category) => array.filter((item) => {
        if (category) {
            let categorie = item.category;
            let arr = category.split("|").map(i => i.trim());
            return categorie.includes(arr[0]) && categorie.includes(arr[1]) ? true : false;
        } else {
            return array
        }

    });

    const popular_list = (array) => array.filter((item) => {
        let sales = parseInt(item.sales)
        return sales > 0;
    }
    );
    const discount_list = (array) => array.filter((item) => {
        let price = parseInt(item.price)
        let discount = parseInt(item.discount)
        return price < discount;
    }
    );
    const page_list = (array, page) => {
        const size = 28;
        const subarray = [];
        for (let i = 0; i < Math.ceil(array.length / size); i++) {
            subarray[i] = array.slice((i * size), (i * size) + size);
        }
        return subarray[page - 1]
    };
    const instock_list = (array) => {
        const outofstock = array.filter((item) => item.stock_status === 'outofstock');
        const instock = array.filter((item) => item.stock_status === 'instock');
        return instock.concat(outofstock);
    }


    app.get('/goods/:goodId', async (req, res) => {
        try {
            const good = await dbf.get_good(db, req.params.goodId);
            const data_img = await dbf.get_good_images(db, req.params.goodId);
            const attributes = await dbf.get_good_attr(db, req.params.goodId);
            if (!good.length == 0) {
                const data = Object.assign(good[0], { images: data_img ,attributes: attributes })
                res.status(200).send(data);
            } else {
                res.status(404).send({ msg: "Not Found", ID: req.params.goodId, data: Date() });
            }
        } catch (err) {
            res.status(500).send({ msg: "Error", error: err, date: Date() });
        }
    });


    app.get('/home', async (req, res) => {
        try {
            const results = await dbf.get_home(db);
            res.status(200).send({
                images: [{
                    original: "https://imagebee.org/brands/apple-tree/apple-tree-wallpapers-2560x1440.jpg",
                    thumbnail: "https://imagebee.org/brands/apple-tree/apple-tree-wallpapers-2560x1440.jpg"
                },
                {
                    original: "https://www.desktopbackground.org/download/o/2015/01/24/891879_apple-tree-wallpapers_1920x1080_h.jpg",
                    thumbnail: "https://www.desktopbackground.org/download/o/2015/01/24/891879_apple-tree-wallpapers_1920x1080_h.jpg"
                }
                    ,
                {
                    original: "https://www.desktopbackground.org/download/o/2015/01/24/891879_apple-tree-wallpapers_1920x1080_h.jpg",
                    thumbnail: "https://www.desktopbackground.org/download/o/2015/01/24/891879_apple-tree-wallpapers_1920x1080_h.jpg"
                }
                    ,
                {
                    original: "https://www.desktopbackground.org/download/o/2015/01/24/891879_apple-tree-wallpapers_1920x1080_h.jpg",
                    thumbnail: "https://www.desktopbackground.org/download/o/2015/01/24/891879_apple-tree-wallpapers_1920x1080_h.jpg"
                }],
                popular: popular_list(results).slice(0, 8),
                discount: discount_list(results).slice(0, 3),
            });
        } catch (err) {
            res.status(500).send({ msg: "Error", error: err, date: Date() });
        }
    });

    app.get('/shop', async (req, res) => {
        try {

            const page = parseInt(req.query.page) || null;
            const search = req.query.search || "";
            const category = req.query.category || "";
            const items_db = await dbf.get_search_items(db, search);
            const items_sort = instock_list(items_db)
            if (page) {
                const categories_db = categories_list(items_sort, category)
                const get_page_data = page_list(categories_db, page)
                if (get_page_data) {

                    res.status(200).send({ shop: get_page_data, total: categories_db.length, total_page: get_page_data.length });
                }
                else {
                    res.status(404).send({ msg: "Not Found", date: Date() });
                }

            }
            else {
                const categories_db = categories_list(items_sort, category)
                if (categories_db.length) {


                    res.status(200).send({ shop: categories_db, total: categories_db.length })
                }
                else {
                    res.status(404).send({ msg: "Not Found", date: Date() });
                }

            }
        } catch (err) {
            res.status(500).send({ msg: "Error", "Error": err, date: Date() });
        }

    });

    app.post('/offer', async (req, res) => {
        try {
            const data = await wooapi.make_order(req.body, woo_api)

            res.status(data.statusCode).send({data: data.body});
        } catch (err) {
            res.status(500).send({ msg: "Error", error: err, date: Date() });
        }


    });

    app.post('/bookItem', async (req, res) => {
        try {
            const data = await wooapi.book_item(req.body, woo_api)

            res.status(data.statusCode).send({data: data.body});
        } catch (err) {
            res.status(500).send({ msg: "Error", error: err, date: Date() });
        }


    });

    app.get('/test', async (req, res) => {
        try {
            const data = await dbf.test_querry(db)
            res.status(200).send(data);
        } catch (err) {
            res.status(500).send({ msg: "Error", error: err, date: Date() });
        }


    });

    app.get('/checkout-settings', async (req, res) => {
        try {
            const data = await dbf.checkout_querry(db)
            res.status(200).send(data);
        } catch (err) {
            res.status(500).send({ msg: "Error", error: err, date: Date() });
        }


    });

    app.get('/', async (req, res) => {
        try {
            res.status(200).send({ api: "/api/v1", version: "v1", name: "WP-NODE_V_1.2.4" });
        } catch (err) {
            res.status(500).send({ msg: "Error", error: err, date: Date() });
        }


    });
};