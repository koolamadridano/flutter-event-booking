const ReportUser = require("../../models/tickets/report-user");

const createReportUserTicket = async (req, res) => {
    try {
        return new ReportUser(req.body)
            .save()
            .then((value) => res.status(200).json(value))
            .catch((err) => res.status(400).send(err.errors));
    } catch (error) {
        console.error(error);
    }
};

const getAllReportUserTickets = async (req, res) => {
    try {
        return ReportUser.find({})
            .sort({ createdAt: -1 }) // filter by date
            .select({  __v: 0 }) // Do not return _id and __v
            .then((value) => res.status(200).json(value))
            .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.error(error);
    }
};

const updateReportUser = async (req, res) => {
    try {
        const { _id, opened } = req.body;;
        ReportUser.findByIdAndUpdate({ _id },
            { opened },
            { new: true})
            .then((value) => res.status(200).json(value))
                .catch((err) => console.log(err));
       
    } catch (error) {
        console.error(error);
    }
};

const deleteReportUserTicket = async (req, res) => {
    try {
        const _id = req.params.id;
        ReportUser.findByIdAndDelete(_id)
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
    createReportUserTicket, 
    getAllReportUserTickets, 
    updateReportUser,
    deleteReportUserTicket
};
