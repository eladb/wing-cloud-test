bring cloud;
bring http;

let api = new cloud.Api();

api.get("/greet/:name", inflight (req) => {
  let name = req.vars.get("name");
  let var message = "Hello, {name}!";
  if let _ = req.query.tryGet("caps") {
    message = message.uppercase();
  }
  return {
    status: 200,
    body: message,
  };
});

test "GET /greet/:name" {
  let res = http.get("{api.url}/greet/world", body: "Hello, world!");
  assert(res.status == 200);
  assert(res.body == "Hello, world!");
}

test "GET /greet/:name?caps" {
  let res = http.get("{api.url}/greet/world?caps", body: "Hello, world!");
  assert(res.status == 200);
  assert(res.body == "HELLO, WORLD!");
}
