//jQuery is required :(

window.RMonAPI = function(addr)
{
	this.addr = addr;
	this.query = function(method,data,callback)
	{
		$.ajax(
			addr + "/" + method,
			{
				async: true,
				data: data,
				dataType : "json",
				success:callback,
				error:callback,
				timeout:3000
			}
		);
	};
};