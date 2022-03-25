require("dotenv").config();
const cloudinary = require("../../services/img-upload/cloundinary");
const Verification = require("../../_models/_tickets/_verification");
const Profile = require("../../_models/_profile/_profile");


// POST
async function createVerificationTicket(req, res) {
    try {

        const hasPending = await Verification.findOne({ accountId: req.body.accountId});
        if(hasPending) {
            return res.status(400).send({ message: "Account Id has pending ticket"});
        }
        const filePath = req.file.path;
        const options = { 
            folder: process.env.CLOUDINARY_FOLDER + "/tickets/verification", 
            unique_filename: true 
        };
        const uploadedImg = await cloudinary.uploader.upload(filePath, options);

        req.body.url = uploadedImg.url;

        return new Verification(req.body)
            .save()
            .then((value) => res.status(200).json(value))
            .catch((err) => res.status(400).send(err.errors));
    } catch (error) {
        console.error(error);
    }
}

// GET
async function getAllVerificationTickets(req, res) {
    try {
        return Verification.find()
            .sort({ createdAt: -1 }) // filter by date
            .select({  __v: 0 }) // Do not return _id and __v
            .then((value) => res.status(200).json(value))
            .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.error(error);
    }
};

async function getSingleVerificationTicket(req, res) {
    try {
        const accountId = req.params.id;
        return Verification.findOne({ accountId })
            .then((value) => {
                if (value) 
                    return res.status(200).json(value);
                return res.status(400).json({ message: "accountId doesn't exist or has already been deleted"});
            })
            .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.error(error);
    }
};

// UPDATE
async function updateProfileVerificationStatus(req, res) {
    try {
        const _id = req.body.verificationObjId;
        const accountId = req.body.accountId;
        const status = req.body.status;

        // UPDATE PROFILE STATUS
        Profile.findOneAndUpdate(
            { accountId },
            { status })
                .then((value) => console.log({message: "updated"}))
                .catch((err) => console.log(err));
       
        // UPDATE SUBMITTED TICKET
        Verification.findOneAndUpdate(
            { _id },
            { status })
            .then((value) => {
                if (value) 
                    return res.status(200).json({ message: "updated"});
                return res.status(400).json({ message: "_id doesn't exist or has already been deleted"});
            })
            .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.error(error);
    }
};

// DELETE
async function deleteVerificationTicket(req, res) {
    try {
        const _id = req.params.id;
        Verification.findByIdAndDelete(_id)
            .then((value) => {
                if (value) 
                    return res.status(200).json({ message: "deleted"});
                return res.status(200).json({ message: "_id doesn't exist or has already been deleted"});
            })
            .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.log(error);
    }
};


module.exports = { 
    createVerificationTicket, 
    getAllVerificationTickets, 
    getSingleVerificationTicket,  
    updateProfileVerificationStatus,
    deleteVerificationTicket
};
