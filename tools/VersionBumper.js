(function()
{
	
	var MAJOR = "-major";
	var MINOR = "-minor";
	var PATCH = "-patch";
	
	var mode = process.argv[3];
	
	if (mode != MAJOR && mode != MINOR && mode != PATCH)
	{
		throw "Mode " + mode + " wasn't recognized.\nUse \"" + MAJOR + "\", \"" + MINOR + "\" or \"" + PATCH + "\".";
	}
	
	var projectPath = process.argv[2];
	var versionPath = projectPath + "/assets/version";
	
	var fileSystem = require("fs");
	var versionString = fileSystem.readFileSync(versionPath, {encoding: "utf8"});
	
	var parts = versionString.split(".");
	
	if (mode == MAJOR)
	{
		parts[0] = parseInt(parts[0]) + 1;
		parts[1] = 0;
		parts[2] = 0;
	}
	else if (mode == MINOR)
	{
		parts[1] = parseInt(parts[1]) + 1;
		parts[2] = 0;
	}
	else if (mode == PATCH)
	{
		parts[2] = parseInt(parts[2]) + 1;
	}
	
	var version = parts.join(".");
	
	fileSystem.writeFileSync(versionPath, version);
	console.log(mode.charAt(1).toUpperCase() + mode.substring(2) + " bumped to version v" + version);
	
})();