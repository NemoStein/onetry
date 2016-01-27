(function()
{
	
	var projectPath = __dirname + "/..";
	
	var outputPath = projectPath + "/devBundle";
	var outputBinPath = outputPath + "/bin";
	var outputAssetsPath = outputPath + "/assets";
	
	var inputSwfPath = projectPath + "/bin/OneTry.swf";
	var inputAssetsPath = projectPath + "/assets";
	
	var fileSystem = require("fs");
	
	// File system's generic recursion method
	var recurse = function(path, callback, post)
	{
		if (fileSystem.existsSync(path))
		{
			if (!post)
			{
				callback(path);
			}
			
			fileSystem.readdirSync(path).forEach(function(file, index)
			{
				var currentPath = path + "/" + file;
				
				if (fileSystem.statSync(currentPath).isDirectory())
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
				callback(path);
			}
		}
	};
	
	// Deleting output folder recursively (cleaning old trash)
	recurse(outputPath, function(path)
	{
		if (fileSystem.statSync(path).isDirectory())
		{
			fileSystem.rmdirSync(path);
		}
		else
		{
			fileSystem.unlinkSync(path);
		}
	}, true);
	
	// Creating output folder again
	fileSystem.mkdirSync(outputPath);
	
	/****************************************************************************/
	/*** Copying assets *********************************************************/
	
	recurse(inputAssetsPath, function(from)
	{
		var to = outputAssetsPath + from.substr(inputAssetsPath.length)
		
		if (fileSystem.statSync(from).isDirectory())
		{
			fileSystem.mkdirSync(to);
		}
		else
		{
			fileSystem.createReadStream(from).pipe(fileSystem.createWriteStream(to));
		}
		
	}, false);
	
	/****************************************************************************/
	/*** Copying bin ************************************************************/
	
	fileSystem.mkdirSync(outputBinPath);
	fileSystem.createReadStream(inputSwfPath).pipe(fileSystem.createWriteStream(outputBinPath + "/OneTry.swf"));
	
})();