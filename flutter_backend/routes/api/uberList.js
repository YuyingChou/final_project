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

//search uber list
router.get('/searchList', async (req, res) => {
    try {
        //從query參數中獲取搜尋條件
        const startingLocationKeyword = req.query.startingLocation;
        const destinationKeyword = req.query.destination;
        const selectedDateTime = req.query.selectedDateTime;
        const wantToFindRide = req.query.wantToFindRide;
        const wantToOfferRide = req.query.wantToOfferRide;

        //查詢條件
        const searchConditions = {};

        // $regex(Regular Expression) => 關鍵字搜尋
        if (startingLocationKeyword) {
            searchConditions.startingLocation = { $regex: new RegExp(startingLocationKeyword, 'i') };
        }

        if (destinationKeyword) {
            searchConditions.destination = { $regex: new RegExp(destinationKeyword, 'i') };
        }
        
        //$gte => 大於等於運算符
        if (selectedDateTime) {
            searchConditions.selectedDateTime = { $gte: new Date(selectedDateTime) }; 
        }

        if (wantToFindRide !== undefined) {
            searchConditions.wantToFindRide = wantToFindRide;
        }

        if (wantToOfferRide !== undefined) {
            searchConditions.wantToOfferRide = wantToOfferRide;
        }

        //檢查是否有任何搜索條件
        const hasSearchConditions = Object.keys(searchConditions).length > 0;
        //使用搜尋條件查詢UberList
        const uberList = hasSearchConditions
            ? await UberList.find(searchConditions)
            : await UberList.find();

        const responseData = {
            success: true,
            data: uberList
        };
        res.status(200).json(responseData);
    } catch (err) {
        res.status(400).json({ success: false, error: err.message });
    }
});



//edit list 
router.put('/updatedList/:id', async (req, res) => {
    try {
      const editList = await UberList.findByIdAndUpdate(
        req.params.id, 
        req.body, 
        { new: true }
      );
      if (!editList) {
        res.status(400).json({ message: '找不到此清單' });
        return;
      } 
      res.status(200).json(editList);
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: '服务器错误' });
    }
});

module.exports = router;
