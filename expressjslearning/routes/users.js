const express = require("express");
const router = express.Router()
// router.get("/", (req, res)=>{
//     res.send("userslist")
// })
router.post("/", (req, res)=>{
    res.send("create users")
})
router.route("/:id").get((req, res)=>{
    req.params.id 
    res.send('get user with id ${req.params.id}')
}).put((req, res)=>{
    res.send('update user with id ${req.params.id}')
}).delete((req, res)=>{res.send('delete user with id ${req.params.id}')});
//middleware 
router.param("id", (req, res, next, id)=>{
    console.log(id)
    next()
});

module.exports = router;