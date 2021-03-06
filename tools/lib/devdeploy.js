var path = require('path');
var fs = require('fs');

// File system's generic recursion method
var recurse = function(filename, callback, post)
{
	if (fs.existsSync(filename))
	{
		if (!post)
		{
			callback(filename);
		}
		
		fs.readdirSync(filename).forEach(function(file, index)
		{
			var currentPath = path.join(filename, file);
			
			if (fs.statSync(currentPath).isDirectory())
			{
				recurse(currentPath, callback, post);
			}
			else
			{
				callback(currentPath);
			}
		});
		
		if (post)
		{
			callback(filename);
		}
	}
};

module.exports = function(args, basepath)
{
	console.log('Dev Bundle Deployer by NemoStein');
	
	var inputSwfPath = path.join(basepath, '/bin/OneTry.swf');
	var inputAssetsPath = path.join(basepath, '/assets');
	
	var outputPath = path.join(basepath, '/devBundle');
	var outputBinPath = path.join(outputPath, '/bin');
	var outputAssetsPath = path.join(outputPath, '/assets');

	// Deleting output folder recursively (cleaning old trash)
	recurse(outputPath, function(path)
	{
		if (fs.statSync(path).isDirectory())
		{
			fs.rmdirSync(path);
		}
		else
		{
			fs.unlinkSync(path);
		}
	}, true);
	
	// Creating output folder again
	fs.mkdir(outputPath, function(error)
	{
		if (error)
		{
			throw error;
		}
		
		/****************************************************************************/
		/*** Copying assets *********************************************************/
		
		recurse(inputAssetsPath, function(from)
		{
			var to = path.join(outputAssetsPath, from.substr(inputAssetsPath.length));
			
			if (fs.statSync(from).isDirectory())
			{
				fs.mkdirSync(to);
			}
			else
			{
				fs.createReadStream(from).pipe(fs.createWriteStream(to));
			}
		
		});
		
		/****************************************************************************/
		/*** Copying bin ************************************************************/
		
		fs.mkdir(outputBinPath, function()
		{
			fs.createReadStream(inputSwfPath).pipe(fs.createWriteStream(outputBinPath + '/OneTry.swf'));
			
			console.log('devBundle deployed successfully.');
		});
	});
};
