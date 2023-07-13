//where we're gonna put all our serve code
const expressServer = require('express');
const app = expressServer();
app.set('view engine', 'ejs');
app.use(expressServer.json());
app.get("/", (req, res)=>{console.log('here I am')
//res.send('hi') 
res.render('index',{text: "world"})})

const userRouter = require("./routes/users")
const messageRouter = require("./routes/calls")
app.use("/messages", messageRouter)
app.use("/users", userRouter)
app.listen(65341, ()=>{console.log('Server listening at http://localhost:65000}/')});