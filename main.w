bring cloud;
bring http;
bring containers;

let api = new cloud.Api();

api.get("/", inflight () => {
  return { body: "hello!" };
});

api.get("/dune", inflight () => {
  return { body: "where is RAZ" };
});

api.post("/greet/:name", inflight (req) => {
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

test "POST /greet/:name" {
  let res = http.post("{api.url}/greet/world", body: "Hello, world!");
  assert(res.status == 200);
  assert(res.body == "Hello, world!");
}

test "POST /greet/:name?caps" {
  let res = http.post("{api.url}/greet/world?caps", body: "Hello, world!");
  assert(res.status == 200);
  assert(res.body == "HELLO, WORLD!");
}

let workload = new containers.Workload(
  name: "my-app",
  image: "./my-app",
  port: 3000,
  public: true
);

new cloud.Endpoint(workload.publicUrl!);
