var path = require('path');
var fs = require('fs');
var xml2js = require('xml2js');
var util = require('util');

var mapsPath;
var fileCount = 0;
var fileProcessed = 0;

var parse = function(string)
{
	var tiles = string.split('\n');
	
	for (var y = 0; y < tiles.length; ++y)
	{
		tiles[y] = tiles[y].split(',');
		for (var x = 0; x < tiles[y].length; ++x)
		{
			tiles[y][x] = parseInt(tiles[y][x]);
		};
	};
	
	return tiles;
};

var crop = function(tiles, bounds)
{
	var count;
	
	for (var y = 0; y < tiles.length; ++y)
	{
		var cols = tiles[y].length;
		
		if (bounds.right < cols)
		{
			count = cols - bounds.right;
			while (count-- > 0)
			{
				tiles[y].pop();
			}
		}
		else
		{
			count = bounds.right - cols;
			while (count-- > 0)
			{
				tiles[y].push(-1);
			}
		}
		
		if (bounds.left < 0)
		{
			count = -bounds.left;
			while (count-- > 0)
			{
				tiles[y].unshift(-1);
			}
		}
		else
		{
			count = bounds.left;
			while (count-- > 0)
			{
				tiles[y].shift();
			}
		}
	};
	
	var row = [];
	var rows = tiles.length;
	
	for (var i = 0; i < tiles[0].length; ++i)
	{
		row.push(-1);
	};
	
	if (bounds.bottom < rows)
	{
		count = rows - bounds.bottom;
		while (count-- > 0)
		{
			tiles.pop();
		}
	}
	else
	{
		count = bounds.bottom - rows;
		while (count-- > 0)
		{
			tiles.push(row);
		}
	}
	
	if (bounds.top < 0)
	{
		count = -bounds.top;
		while (count-- > 0)
		{
			tiles.unshift(row);
		}
	}
	else
	{
		count = bounds.top;
		while (count-- > 0)
		{
			tiles.shift();
		}
	}
	
	for (var y = 0; y < tiles.length; ++y)
	{
		tiles[y] = tiles[y].join(',');
	}
	
	return tiles.join('\n');
};

var translate = function(node, offset)
{
	if (typeof node.x !== 'undefined')
	{
		node.x += offset.x;
	}
	
	if (typeof node.y !== 'undefined')
	{
		node.y += offset.y;
	}
	
	for (var i in node)
	{
		if (typeof node[i] === 'object')
		{
			translate(node[i], offset);
		}
	}
};

var manipulate = function(filename)
{
	fileProcessed = ++fileCount;

	fs.readFile(filename, { encoding: 'utf-8' }, function(error, data)
	{
		if (error)
		{
			throw error;
		}
		
		var parser = new xml2js.Parser({
			explicitArray: false,
			attrValueProcessors: [xml2js.processors.parseNumbers]
		});
		
		parser.parseString(data, function(error, data)
		{
			if (error)
			{
				throw error;
			}
			
			var bounds = {
				top: Infinity,
				right: -Infinity,
				bottom: -Infinity,
				left: Infinity,
			};
			
			var background = parse(data.level.Background._);
			var collision = parse(data.level.Collision._);
			var decals1 = parse(data.level.Decals1._);
			var decals2 = parse(data.level.Decals2._);
			var decals3 = parse(data.level.Decals3._);
			
			for (var y = 0; y < collision.length; ++y)
			{
				for (var x = 0; x < collision[y].length; x++)
				{
					if (collision[y][x] !== -1)
					{
						if (bounds.top > y)
						{
							bounds.top = y;
						}
						
						if (bounds.right < x)
						{
							bounds.right = x;
						}
						
						if (bounds.bottom < y)
						{
							bounds.bottom = y;
						}
						
						if (bounds.left > x)
						{
							bounds.left = x;
						}
					}
				};
			};
			
			bounds.top -= 2;
			bounds.right += 3;
			bounds.bottom += 3;
			bounds.left -= 2;
			
			var width = (bounds.right - bounds.left) * 16;
			var height = (bounds.bottom - bounds.top) * 16;
			
			if (width < 400)
			{
				width = 400;
			}
			
			if (height < 240)
			{
				height = 240;
			}
			
			var offset = {
				x: -bounds.left * 16,
				y: -bounds.top * 16,
			};
			
			translate(data.level.Props, offset);
			
			data.level.$.width = width;
			data.level.$.height = height;
			
			data.level.Background._ = crop(background, bounds);
			data.level.Collision._ = crop(collision, bounds);
			data.level.Decals1._ = crop(decals1, bounds);
			data.level.Decals2._ = crop(decals2, bounds);
			data.level.Decals3._ = crop(decals3, bounds);
			
			data.level.Background.$.tileset = 'Background';
			data.level.Collision.$.tileset = 'Collision';
			data.level.Decals1.$.tileset = 'Decals';
			data.level.Decals2.$.tileset = 'Decals';
			data.level.Decals3.$.tileset = 'Decals';
			
			var builder = new xml2js.Builder({ headless: true });
			var xml = builder.buildObject(data);
			
			fs.writeFile(filename, xml, function(error)
			{
				if (error)
				{
					throw error;
				}
				
				//console.log('Processed map: ' + filename.replace(mapsPath, '').replace(/\\/g, '/').slice(1, -4));
				--fileCount;

				if (fileCount <= 0)
				{
					report();
				}
			});
		});
	});
};

var walk = function(filename)
{
	fs.readdir(filename, function(error, entries)
	{
		if (error)
		{
			throw error;
		}
		
		entries.forEach(function(entry)
		{
			var currentPath = path.join(filename, entry);
			
			fs.stat(currentPath, function(error, stat)
			{
				if (error)
				{
					throw error;
				}

				if (stat.isDirectory())
				{
					walk(currentPath);
				}
				else if (currentPath.slice(-4) === '.oel')
				{
					manipulate(currentPath);
				}
			});
		});
	})
};

var report = function()
{
	console.log('Maps normalizing done... ' + fileProcessed + ' file processed.');
};

module.exports = function(args, basepath)
{
	console.log('Map Cropper by NemoStein');
	
	mapsPath = path.join(basepath, '/assets/maps')
	var filename;
	
	if (args['<map>'])
	{
		if (args['<map>'].endsWith('/*'))
		{
			filename = path.join(mapsPath, args['<map>'].slice(0, -2));
		}
		else
		{
			filename = path.join(mapsPath, args['<map>'] + '.oel');
		}
	}
	else
	{
		filename = mapsPath;
	}
	
	fs.stat(filename, function(error, stat)
	{
		if (error)
		{
			throw error;
		}
		
		if (stat.isDirectory())
		{
			walk(filename);
		}
		else
		{
			manipulate(filename);
		}
	});
};
