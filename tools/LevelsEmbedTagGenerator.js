(function()
{
	
	var projectPath = __dirname + "/..";
	
	var levelsPath = projectPath + "/assets/levels.json";
	var assetsPath = projectPath + "/src/assets.as";
	
	var fileSystem = require("fs");
	var jsonString = fileSystem
		.readFileSync(levelsPath, {encoding: "utf8"})
		.replace(/(\/\/[^\r\n]*|\/\*[^*]*\*\/)/g, "")
	;
	var ids = JSON.parse(jsonString);
	var output = [];
	var used = [];
	
	for (var i = 0; i < ids.length; i++)
	{
		var id = ids[i];
		if (id != "")
		{
			var skip = false;
			
			for (var j = 0; j < used.length; j++)
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
			
			output.push(""
				+ "\t\t\t[Embed(source=\"../assets/maps/" + id + ".oel\",mimeType=\"application/octet-stream\")]\r\n"
				+ "\t\t\tpublic static const MAP_" + id.toUpperCase().replace(/[^0-9A-Z]+/g, "_") + ":Class;"
			);
			used.push(id);
		}
	};
	
	var tags = output.join("\r\n");
	var assetsString = fileSystem.readFileSync(assetsPath, {encoding: "utf8"});
	
	var variableMark = "//!levels";
	var startLine = assetsString.indexOf(variableMark);
	var endLine = assetsString.indexOf("//!", startLine + variableMark.length);
	
	assetsString = assetsString.substring(0, startLine)
		+ variableMark
		+ "\r\n\t\t\t/**"
		+ "\r\n\t\t\t * The following code was automatically generated"
		+ "\r\n\t\t\t * Any change here WILL be lost at the next compiling"
		+ "\r\n\t\t\t */\r\n"
		+ tags + "\r\n\t\t\t"
		+ assetsString.substring(endLine)
	;
	
	fileSystem.writeFileSync(assetsPath, assetsString);
	
})();