var docopt = require('docopt').docopt;
var path = require('path');

/**
var doc = '';
/**/
var doc = `
OneTry Tools
Tools that ease the OneTry assets management and shit!

Usage:
	tools vbump (--major | --minor | --patch)
	tools taggen
	tools devdeploy
	tools mapcrop [<map>]
	tools --help
	tools --version

Options:
	-h --help       Show this screen
	-v --version    Show version
	-M --major      Bumps the major version (x.0.0)
	-m --minor      Bumps the minor version (0.x.0)
	-p --patch      Bumps the patch version (0.0.x)

Bumping increments the part and set the next to zero.
E.g.: With version 2.7.12, passing -m (or --minor) sets the version to 2.8.0
`;
/**/

var args = docopt(doc, { version: '0.3.7' });

if (typeof args === 'string')
{
	console.log(args);
}
else
{
	var tool;

	if (args['vbump'])
	{
		tool = require('./lib/vbump');
	}
	else if (args['taggen'])
	{
		tool = require('./lib/taggen');
	}
	else if (args['devdeploy'])
	{
		tool = require('./lib/devdeploy');
	}
	else if (args['mapcrop'])
	{
		tool = require('./lib/mapcrop');
	}
	
	var basepath = path.join(__dirname, '/..');
	tool(args, basepath);
}