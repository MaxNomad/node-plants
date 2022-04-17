
const data = (req) => ({
    "payment_method": req.payment,
    "payment_method_title": req.payment,
    "set_paid": true,
    "billing": {
        "first_name": ("Клієнт: " + req.name),
        "last_name": "",
        "address_1": req.town == "" ? "" : ("Місто: " + req.town),
        "address_2": req.department == "" ? "" : ("Поштове відділення: " + req.department),
        "city": req.delivery == "" ? "" : ("Спосіб доставки: " + req.delivery),
        "state": "",
        "postcode": "",
        "country": req.comment == "" ? "" : ("Коментар: " + req.comment),
        "email": req.email,
        "phone": req.number
    },
    "shipping": {
        "first_name": ("Клієнт: " + req.name),
        "last_name": "",
        "address_1": req.town == "" ? "" : ("Місто: " + req.town),
        "address_2": req.department == "" ? "" : ("Поштове відділення: " + req.department),
        "city": req.delivery == "" ? "" : ("Спосіб доставки: " + req.delivery),
        "state": "",
        "postcode": "",
        "country": req.comment == "" ? "" : ("Коментар: " + req.comment),
    },
    "line_items": req.line_items
});

const make_order  = async (req, api) => {
  return new Promise((resolve) => {
    api.postAsync("orders", data(req)).then(function(result) {
      resolve(result)
    });

  })

    
}

module.exports = { make_order };


