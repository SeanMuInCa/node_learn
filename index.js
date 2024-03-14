const express = require('express');

const app = express();

app.get('/' , (req , res)=>{

    res.send('hello to our new world');

})

app.get('/api/pikachu' , (req , res)=>{

    res.json({
        pokemon: "pikachu",
        type: "electric",
        feature: "cute!"
    });

});

app.get('/api/bulbasaur' , (req , res)=>{

    res.json({
        pokemon: "bulbasaur",
        type: "grass",
        feature: "cute!"
    });

});

//get the info from last params
app.get('/api/:myParam' , (req , res)=>{

    const eevee = {
        pokemon: "eevee",
        type: "normal",
        feature: "super cute!"
    };

    const data = req.params.myParam;
    // console.log(req.params);
    res.json(eevee[data]);

})


app.listen(3010, function(){
    console.log('really?');
});

