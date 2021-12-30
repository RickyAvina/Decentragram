pragma solidity ^0.5.0;

contract Decentragram {
  string public name = "Decentragram";  

  // Store Posts
  uint public imageCount = 0;
  mapping(uint => Image) public images;

  struct Image {
    uint id;
    string hash;
    string description;
    uint tipAmount;
    address payable author;
  }

  event ImageCreated(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  event ImageTipped(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  // Create Posts
  function uploadImage(string memory _imgHash, string memory _description) public {
    // Make sure image hash exists
    require(bytes(_imgHash).length > 0);
    require(bytes(_description).length > 0);
    // Make sure sender exists
    require(msg.sender != address(0x0));

    imageCount ++;

    images[imageCount] = Image(imageCount, _imgHash, _description, 0, msg.sender);
    
    emit ImageCreated(imageCount, _imgHash, _description, 0, msg.sender);
  }

  // Tip Posts
  function tipImageOwner(uint _id) public payable {
    require(_id > 0 && _id <= imageCount);

    // Fetch image from storage
    Image memory _image = images[_id];

    address payable _author = _image.author;

    // WHAT IS msg.value
    _author.transfer(msg.value);

    _image.tipAmount = _image.tipAmount + msg.value;

    // Update image struct
    images[_id] = _image;

    emit ImageTipped(_id, _image.hash, _image.description, _image.tipAmount, _author);
  }

}