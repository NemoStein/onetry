var path = require('path');
var fs = require('fs');

module.exports = function(args, basepath)
{
	console.log('Levels Embed Tag Generator by NemoStein');
	
	var levelsPath = path.join(basepath, '/assets/levels.json');
	var assetsPath = path.join(basepath, '/src/assets.as');
	
	fs.readFile(levelsPath, { encoding: 'utf-8' }, function(error, data)
	{
		if (error)
		{
			throw error;
		}
		
		// removing line and block comments
		var jsonString = data.replace(/(\/\/[^\r\n]*|\/\*[^*]*\*\/)/g, '');
		
		var ids = JSON.parse(jsonString);
		var output = [];
		var used = [];
		
		for (var i = 0; i < ids.length; ++i)
		{
			var id = ids[i];
			if (id != '')
			{
				var skip = false;
				
				for (var j = 0; j < used.length; ++j)
				{
					if (id == used[j])
					{
						skip = true;
						break;
					}
				}
				
				if (skip)
				{
					continue;
				}
				
				output.push('\t\t\t[Embed(source="../assets/maps/' + id + '.oel",mimeType="application/octet-stream")]');
				output.push('\t\t\tpublic static const MAP_' + id.toUpperCase().replace(/[^0-9A-Z]+/g, '_') + ':Class;');
				
				used.push(id);
			}
		};
		
		var tags = output.join('\r\n');
		
		fs.readFile(assetsPath, { encoding: 'utf-8' }, function(error, data)
		{
			if (error)
			{
				throw error;
			}
			
			var assetsString = data;
			var variableMark = '//!levels';
			var startLine = assetsString.indexOf(variableMark);
			var endLine = assetsString.indexOf('//!', startLine + variableMark.length);
			
			if (startLine == -1 || endLine == -1)
			{
				console.log('No marking was found in input file.');
				process.exit(1);
			}
			
			assetsString = assetsString.substring(0, startLine) 
			+ variableMark 
			+ '\r\n\t\t\t/**' 
			+ '\r\n\t\t\t * The following code was automatically generated' 
			+ '\r\n\t\t\t * Any change here WILL be lost at the next compiling' 
			+ '\r\n\t\t\t */\r\n' 
			+ tags + '\r\n\t\t\t' 
			+ assetsString.substring(endLine)
			;
			
			fs.writeFile(assetsPath, assetsString, function(error, data)
			{
				if (error)
				{
					throw error;
				}
				
				console.log('Embed tags for levels added.');
			});
		});
	});
};
