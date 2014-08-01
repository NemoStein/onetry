(function()
{
	
	var projectPath = process.argv[2];
	
	var outputPath = projectPath + "/devBundle";
	var outputBinPath = outputPath + "/bin";
	var outputAssetsPath = outputPath + "/assets";
	var outputMapsPath = outputAssetsPath + "/maps";
	var outputPropsPath = outputAssetsPath + "/props";
	
	var inputSwfPath = projectPath + "/bin/OneTry.swf";
	var inputAssetsPath = projectPath + "/assets";
	var inputMapsPath = inputAssetsPath + "/maps";
	var inputPropsPath = inputAssetsPath + "/props";
	var inputLevelsPath = inputAssetsPath + "/levels.json";
	var inputTextsPath = inputAssetsPath + "/texts.json";
	
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
	fileSystem.mkdirSync(outputBinPath);
	fileSystem.mkdirSync(outputAssetsPath);
	
	/****************************************************************************/
	/*** Copying maps ***********************************************************/
	
	recurse(inputMapsPath, function(from)
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
	/*** Copying props **********************************************************/
	
	recurse(inputPropsPath, function(from)
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
	
	fileSystem.createReadStream(inputSwfPath).pipe(fileSystem.createWriteStream(outputBinPath + "/OneTry.swf"));
	
	/****************************************************************************/
	/*** Copying jsons **********************************************************/
	
	fileSystem.createReadStream(inputLevelsPath).pipe(fileSystem.createWriteStream(outputAssetsPath + "/levels.json"));
	fileSystem.createReadStream(inputTextsPath).pipe(fileSystem.createWriteStream(outputAssetsPath + "/texts.json"));
	
})();