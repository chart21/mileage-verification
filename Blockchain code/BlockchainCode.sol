pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;
contract Mileage {
   
        struct Odometer
    {
        uint256 carID;
        uint256 odometerID;
        address odometerAddress;
        uint256[] timestamps;
        uint256[] values;
        string carModel;
        uint256 start_Time;
    }
    
    mapping(uint256 => bool) oIDisTaken;
    mapping(uint256 => bool) cIDisTaken;
    Odometer[] odometers;
    mapping(address => uint256) odometerAddressToID;
    
    mapping(uint256 => uint256) odometerCarIDToID;
    
    mapping(address => bool) isInitialized;
       
       
       
         constructor() public {
        Odometer memory odometer;
          odometer.carID = 0;
          odometer.odometerID = 0;
          odometer.carModel = "genesis";
          odometer.start_Time = block.timestamp;
          
          odometers.push(odometer);
          
          oIDisTaken[0] = true;
          cIDisTaken[0] = true;
    }
    
      function addOdometer(string memory carModel, uint256 carID, uint256 odometerID) public {
          require(oIDisTaken[odometerID] == false && cIDisTaken[carID] == false);
          require(isInitialized[msg.sender] == false);
        
          Odometer memory odometer;
          odometer.carID = carID;
          odometer.odometerID = odometerID;
          odometer.odometerAddress = msg.sender;
          odometer.carModel = carModel;
          odometer.start_Time = block.timestamp;
          
          odometers.push(odometer);
          
          oIDisTaken[odometerID] = true;
          cIDisTaken[carID] = true;
          odometerAddressToID[msg.sender] = odometers.length-1;
          
          odometerCarIDToID[carID] = odometers.length-1;
          
          isInitialized[msg.sender] = true;
          
      }
      
      

      function addValue(uint256 value) public
      {
        require(odometerAddressToID[msg.sender] != 0); //evtl auf 0 keinen wert setzen
         odometers[odometerAddressToID[msg.sender]].timestamps.push(block.timestamp);
         odometers[odometerAddressToID[msg.sender]].values.push(value);
      }
      
      function getOdometers() public view returns(Odometer[] memory)
      {
       return odometers;   
      }
      
      function getOdometerFromIndex(uint256 index) public view returns(Odometer memory)
      {
       return odometers[index];   
      }
      
}