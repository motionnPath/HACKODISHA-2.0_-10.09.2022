const { getNamedAccounts,deployments } = require("hardhat");


module.exports = async function({getNamedAccounts,deployments}){

    const {log,deploy} = deployments;
    const {deployer} = await getNamedAccounts();

    log("Deploying FundMe and waiting for confirmations...")
    const patientPass = deploy("PatientPass",{
        from:deployer,
        args:[],
        log:true,
        waitConfirmations:1

    })
    log(`FundMe deployed at ${patientPass.address}`)
    console.log('-------------------------------------')
}

module.exports.tags = ["all", "pass"];