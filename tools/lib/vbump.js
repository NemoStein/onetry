var path = require('path');
var fs = require('fs');

module.exports = function(args, basepath)
{
	console.log('VersionBumper by NemoStein');
	
	var versionPath = path.join(basepath, '/assets/version');
	
	fs.readFile(versionPath, { encoding: 'utf-8' }, function(error, data)
	{
		if (error)
		{
			throw error;
		}
		
		var oldVersion = data;
		var parts = oldVersion.split('.');
		
		if (args['--major'])
		{
			parts[0] = parseInt(parts[0]) + 1;
			parts[1] = 0;
			parts[2] = 0;
		}
		else if (args['--minor'])
		{
			parts[1] = parseInt(parts[1]) + 1;
			parts[2] = 0;
		}
		else if (args['--patch'])
		{
			parts[2] = parseInt(parts[2]) + 1;
		}
		
		var newVersion = parts.join('.');
		
		fs.writeFile(versionPath, newVersion, function(error, data)
		{
			if (error)
			{
				throw error;
			}
			
			console.log('Bumped from v' + oldVersion + ' to version v' + newVersion);
		});
	});
};
