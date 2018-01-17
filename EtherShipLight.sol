pragma solidity ^0.4.19;

contract EtherShipLite {

    mapping (address => DrivingNode) drivingNodes;
    DrivingNode[] allNodes;

    struct Location {
        //40.7458722 degrees North would be represented as 407458722
        //74.0268891 degrees East would be represented as -740268891
        uint16 lattitude;
        uint16 longitude;
    }
    struct DrivingNode {
        Location location;
        uint drivingRadius;
        bytes PGPkey;
    }

    function register(uint16 _lattitude, uint16 _longitude, uint _drivingRadius, bytes _PGPkey) public {
        DrivingNode memory newNode;
        newNode = DrivingNode(Location(_lattitude, _longitude), _drivingRadius, _PGPkey);
        allNodes.push(newNode);
        if (drivingNodes[msg.sender].drivingRadius == 0) {
            drivingNodes[msg.sender] = newNode;
        }
    }

    //This squares some big-ass numbers and uses a 'sqrt' function I got off stackoverflow because
    //Solidity doesn't have a native square root yet. Idk if this square root function is even any
    //good, let lone if it guzzles gas like a World War I Sherman M4 tank
    function getIntersectingNodes(DrivingNode _node) returns (DrivingNode[] nodes) {
        DrivingNode[] rNodes;
        for (uint i = 0; i<allNodes.length; i++) {
            uint latSquares = (_node.location.lattitude-allNodes[i].location.lattitude)*(_node.location.lattitude-allNodes[i].location.lattitude);
            uint longSquares = (_node.location.longitude-allNodes[i].location.longitude)*(_node.location.longitude-allNodes[i].location.longitude);
            if (sqrt(latSquares + longSquares) <= (_node.drivingRadius + allNodes[i].drivingRadius)) {
                rNodes.push(allNodes[i]);
            }

        }
        return rNodes;
    }

    function sqrt(uint x) internal returns (uint y) {
        uint z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }

}
