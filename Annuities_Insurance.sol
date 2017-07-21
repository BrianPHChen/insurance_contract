contract AnnuitiesInsurance {
    address beneficiary;
    address insuranceCompany;
    //householdRegistrationOffice
    address HRO;
    uint paymentValuePerMonth;
    mapping (string => bytes32) sha3msg;

    event CheckStatus(address beneficiary);
    event TransferForm (address _to, uint _value);

    // insurance_company deploy the contract
    function AnnuitiesInsurance(address _beneficiary, address _HRO, uint _paymentValuePerMonth) payable {
        beneficiary = _beneficiary;
        HRO = _HRO;
        insuranceCompany = msg.sender;
        paymentValuePerMonth = _paymentValuePerMonth;
        sha3msg['true'] = sha3('true');
        sha3msg['false'] = sha3('false');
    }

    function checkStatus (address beneficiary) {
        CheckStatus(beneficiary);
    }

    function verify(string alive, bytes32 r, bytes32 s, uint8 v) constant returns (address) {
        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        bytes32 prefixedHash = sha3(prefix, sha3msg[alive]);
        address signer = ecrecover(prefixedHash, v, r, s);
        return signer;
    }

    function payment(string alive, bytes32 r, bytes32 s, uint8 v) payable {
        address signer = verify(alive, r, s, v);

        // Only 3rd party can provide the status of the beneficiary
        // check if the signature is signed by HRO
        if (signer != HRO) revert();
        
        if(alive) {
            if ( !beneficiary.send(paymentValuePerMonth) ) revert();
            TransferForm(beneficiary, paymentValuePerMonth);
        }
        else {
            TransferForm(insuranceCompany, this.balance);
            selfdestruct(insuranceCompany);
        }
    }
}