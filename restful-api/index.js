//import
const express = require("express");
const mongoose = require("mongoose");

mongoose.set("strictQuery", true);

const userName = "Zhenghua_Mu";
const pwd = "123456abc";
const dbname = "music_app";
const uri = `mongodb+srv://${userName}:${pwd}@cluster0.i53ojqm.mongodb.net/${dbname}?retryWrites=true&w=majority`; //&appName=Cluster0

mongoose
    .connect(uri)
    .then((res) => {
        console.log("connected to mongoDB");
    })
    .catch((reason) => {
        console.log(reason);
    });

const musicSchema = new mongoose.Schema({
    album: { type: String, required: true }, //change to true to test
    artist: { type: String, required: false },
    year: { type: Number, required: false },
    artwork: { type: String, required: false }
});

const Album = mongoose.model("Album", musicSchema); //mongodb will automatically updated your database name to s,in my case it's albums
// methods available via mongoose model:
// find()
// findById()
// findOne()
// findOneAndDelete()
// findByIdAndDelete()

const backend = express();

backend.use(express.json());

//root route
backend.get("/", (req, res) => {
    res.redirect("/music");
    console.log("someone is coming to root and redirect to music");
    //res.send('hello world in root');
});

//get all routes
backend.get("/music", (req, res) => {
    console.log("someone is coming to music");
    Album.find()
        .then((albums) => {
            if (!albums.length) {
                return res
                    .status(404)
                    .json({ success: false, data: "No albums found." });
            }
            return res.status(200).json({ success: true, data: albums });
        })
        .catch((reason) => {
            return res.status(400).json({ success: false, error: reason });
        });
});

//get by id route
backend.get("/music/:id", (req, res) => {
    console.log("someone is coming to music by id");
    Album.findById(req.params.id)
        .then((data) => {
            //mongodb checks the id is legal or not, if it possible legal, it will return something
            return res.status(200).json({ success: true, data: data });
        })
        .catch((reason) => {
            return res.status(400).json({ success: false, error: reason });
        });
});

//create route
backend.post("/music", (req, res) => {
    console.log("someone is coming to music to post");
    const bodyInfo = req.body;
    if (bodyInfo.constructor === Object && Object.keys(bodyInfo).length === 0) {
        // is a empty object
        return res
            .status(400)
            .json({ success: false, error: "you must provide album information" });
    }
    const newAlbum = new Album(bodyInfo);

    if (!newAlbum) {
        return res
            .status(400)
            .json({ success: false, error: "album creation failed" });
    }

    newAlbum
        .save()
        .then(() => {
            return res.status(201).json({
                success: true,
                id: newAlbum._id,
                message: "album created successed!"
            }); //201 for post sucess
        })
        .catch((reason) => {
            return res
                .status(400)
                .json({ success: false, error: reason, message: "album not created" });
        });
});

backend.listen("3001", () => {
    console.log("server on 3001");
});

//practice
// const musicSchema = new mongoose.Schema({
//     album: String,//that's ok too
//     artist: {type: String, required: false},
//     year: {type: Number, required: false},
//     artwork: [String]
// });

//practice
// const customers = new mongoose.Schema({
//     username: String,
//     name: String,
//     address: String,
//     birthdate: Date,
//     email: String,
//     accounts: [Number],
//     tier_and_details: [
//         {
//             tier: String,
//             id:String,
//             active: Boolean,
//             benefits: [String]
//         }
//     ]
// })
