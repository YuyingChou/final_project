const router = require('express').Router();
const UberList = require('../../models/UberList');

//add uber list
router.post('/addUberList',async (req, res)=>{
    try {
        //create new uber list
        const newUberList = new UberList({
            userId: req.body.userId,
            anotherUserId: req.body.anotherUserId,
            reserved: req.body.reserved,
            startingLocation: req.body.startingLocation,
            destination: req.body.destination,
            selectedDateTime: req.body.selectedDateTime,
            wantToFindRide: req.body.wantToFindRide,
            wantToOfferRide: req.body.wantToOfferRide,
        });

        //save uberlist and sned response
        const uberlist = await newUberList.save();
        res.status(200).json({ success: true, message: "新增成功" });
    } catch (err) {
        res.status(400).json({ success: false, error: err.message });
    }
});

//get all uber list
router.get('/getAllList',async(req,res)=>{
    try {
        const uberList = await UberList.find();

        const responseData = {
            success: true,
            data: uberList
        };
        res.status(200).json(responseData);
    } catch (err) {
        res.status(400).json({ success: false, error: err.message });
    }
});

module.exports = router;
