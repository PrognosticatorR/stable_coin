// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract ERC20 {
	uint256 public totalSupply;
	string public name;
	string public symbol;
	mapping(address => uint256) public balanceOf;
	mapping(address => mapping(address => uint256)) public allowance;

	event Transfer(address to, address from, uint256 amount);

	constructor(string memory _name, string memory _symbol) {
		name = _name;
		symbol = _symbol;
		_mint(msg.sender, 100e18);
	}

	function decimals() public pure returns (uint8) {
		return 18;
	}

	function transfer(address _to, uint256 _amount) external returns (bool success) {
		return _transfer(msg.sender, _to, _amount);
	}

	function _transfer(
		address _from,
		address _to,
		uint256 _amount
	) private returns (bool success) {
		require(_to != address(0), "ERC20: cant sends to zero address");
		require(balanceOf[_from] >= _amount, "ERC20: cant transfer more then balance");
		balanceOf[_from] -= _amount;
		balanceOf[_to] += _amount;
		return true;
	}

	function transferFrom(
		address _owner,
		address _receiver,
		uint256 _amount
	) public returns (bool) {
		require(allowance[_owner][msg.sender] >= _amount, "ERC20: not have enough allowance");
		allowance[_owner][msg.sender] -= _amount;
		return _transfer(_owner, _receiver, _amount);
	}

	function approve(address _spender, uint256 _amount) public returns (bool) {
		require(_spender != address(0), "ERC20: approve to zero address");
		require(balanceOf[msg.sender] >= _amount, "ERC20: approve more then balance");
		allowance[msg.sender][_spender] += _amount;
		return true;
	}

	function _mint(address _to, uint256 _amount) internal {
		require(_to != address(0), "ERC20: mint to zero address");
		totalSupply += _amount;
		balanceOf[_to] += _amount;
		emit Transfer(_to, address(0), _amount);
	}

	function _burn(address _from, uint256 _amount) internal {
		require(_from != address(0), "DPC: burn from zero address");
		totalSupply -= _amount;
		balanceOf[_from] -= _amount;
		emit Transfer(address(0), _from, _amount);
	}
}
