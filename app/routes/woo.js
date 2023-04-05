
const data = (req) => {
  let department = "";
  let city = "";

  switch (req.delivery) {
    case 'Укрпошта - адреснa доставкa':
      department = req.department == "" ? "" : ("Індекс відділення: " + req.department);
      city = req.town == "" ? "" : ("Адреса клієнта: " + req.town);
      break;
    case 'Укрпошта - відділення':
      department = req.department == "" ? "" : ("Індекс відділення: " + req.department);
      city = "";
      break;
    case 'Нова пошта':
      department = req.department == "" ? "" : ("Поштове відділення: " + req.department);
      city = req.town == "" ? "" : ("Місто: " + req.town);
      break;
    default:
      department = req.department == "" ? "" : ("Поштове відділення: " + req.department);
      city = req.town == "" ? "" : ("Місто: " + req.town);
  }

  const shape = {
    "payment_method": req.payment,
    "payment_method_title": req.payment,
    "set_paid": true,
    "billing": {
      "first_name": ("Клієнт: " + req.name),
      "last_name": "",
      "address_1": city,
      "address_2": department,
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
      "address_1": city,
      "address_2": department,
      "city": req.delivery == "" ? "" : ("Спосіб доставки: " + req.delivery),
      "state": "",
      "postcode": "",
      "country": req.comment == "" ? "" : ("Коментар: " + req.comment),
    },
    "line_items": req.line_items
  }
  return shape
}

const bookData = (req) => {


  const shape = {
    "payment_method": "",
    "payment_method_title": "",
    "set_paid": true,
    "status": "bookitem",
    "billing": {
      "first_name": ("Клієнт: " + req.name),
      "last_name": "",
      "address_1": "",
      "address_2": "",
      "city": "",
      "state": "",
      "postcode": "",
      "country": "",
      "email": req.email,
      "phone": req.number
    },
    "shipping": {
      "first_name": ("Клієнт: " + req.name),
      "last_name": "",
      "address_1": "",
      "address_2": "",
      "city":"",
      "state": "",
      "postcode": "",
      "country": ""
    },
    "line_items": req.line_items
  }
  return shape
}



const make_order = async (req, api) => {
  return new Promise((resolve) => {
    api.postAsync("orders", data(req)).then((result) => {
      resolve(result)
    });
  })
}

const book_item = async (req, api) => {
  return new Promise((resolve) => {
    api.postAsync("orders", bookData(req)).then((result) => {
      resolve(result)
    });

  })
}

module.exports = { make_order,  book_item};


