const mongoose = require('mongoose');

const UberListSchema = new mongoose.Schema({
    startingLocation: {
        type: String,
        require: true,
        max: 20,
    },
    destination:{
        type: String,
        require: true,
        max: 20,
    },
    selectedDateTime:{
        type: Date,
        require:true,
    },
    wantToFindRide:{
        type: Boolean,
        require:true,
    },
    wantToOfferRide:{
        type: Boolean,
        require:true,
    },
},{ timestamps: true }
); 

module.exports = mongoose.model("UberList", UberListSchema);