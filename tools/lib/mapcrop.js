var path = require('path');
var fs = require('fs');
var xml2js = require('xml2js');
var util = require('util');

var mapsPath;
var margin;
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
			
			if (tiles[y][x] == -1)
			{
				tiles[y][x] = 0;
			}
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
				tiles[y].push(0);
			}
		}
		
		if (bounds.left < 0)
		{
			count = -bounds.left;
			while (count-- > 0)
			{
				tiles[y].unshift(0);
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
		row.push(0);
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

var tiles = (function()
{
	var map = [];
	var set = function(pattern, tile)
	{
		var bits = pattern.split('');
		
		var b0 = (bits[0] != 'x' ?   1 : 0);
		var b1 = (bits[1] != 'x' ?   2 : 0);
		var b2 = (bits[2] != 'x' ?   4 : 0);
		var b3 = (bits[3] != 'x' ?   8 : 0);
		var b4 = (bits[4] != 'x' ?  16 : 0);
		var b5 = (bits[5] != 'x' ?  32 : 0);
		var b6 = (bits[6] != 'x' ?  64 : 0);
		var b7 = (bits[7] != 'x' ? 128 : 0);
		
		for (var i = 0; i < 2; ++i)
		{
			for (var j = 0; j < 2; ++j)
			{
				for (var k = 0; k < 2; ++k)
				{
					for (var l = 0; l < 2; ++l)
					{
						for (var m = 0; m < 2; ++m)
						{
							for (var n = 0; n < 2; ++n)
							{
								for (var o = 0; o < 2; ++o)
								{
									for (var p = 0; p < 2; ++p)
									{
										var key = 0;
										
										key += (bits[0] == '?' && i ? 0 : b0);
										key += (bits[1] == '?' && j ? 0 : b1);
										key += (bits[2] == '?' && k ? 0 : b2);
										key += (bits[3] == '?' && l ? 0 : b3);
										key += (bits[4] == '?' && m ? 0 : b4);
										key += (bits[5] == '?' && n ? 0 : b5);
										key += (bits[6] == '?' && o ? 0 : b6);
										key += (bits[7] == '?' && p ? 0 : b7);
										
										map[key] = tile;
										
										if (bits[7] != '?') break;
									}
									
									if (bits[6] != '?') break;
								}
								
								if (bits[5] != '?') break;
							}
							
							if (bits[4] != '?') break;
						}
						
						if (bits[3] != '?') break;
					}
					
					if (bits[2] != '?') break;
				}
				
				if (bits[1] != '?') break;
			}
			
			if (bits[0] != '?') break;
		}
	};
	
	// Row 1
	// 0 is empty
	set('?x?x?o?x', 1);
	set('?x?ooo?x', 2);
	set('?x?ooooo', 3);
	set('?x?x?ooo', 4);
	// Row 2
	set('xoooxooo', 5);
	set('?o?x?o?x', 6);
	set('?ooooo?x', 7);
	set('oooooooo', 8);
	set('oo?x?ooo', 9);
	// Row 3
	set('ooxoooxo', 10);
	set('?o?x?x?x', 11);
	set('?ooo?x?x', 12);
	set('oooo?x?o', 13);
	set('oo?x?x?o', 14);
	// Row 4
	// 15 is fixed
	set('?x?x?x?x', 16);
	set('?x?o?x?x', 17);
	set('?x?o?x?o', 18);
	set('?x?x?x?o', 19);
	// Row 5
	set('?oxoxo?x', 20);
	set('xo?x?oxo', 21);
	set('ooooxoxo', 22);
	set('ooooxooo', 23);
	set('ooooooxo', 24);
	// Row 6
	set('?x?oxo?x', 25);
	set('?x?x?oxo', 26);
	set('xoxooooo', 27);
	set('ooxooooo', 28);
	set('xooooooo', 29);
	// Row 7
	set('?oxo?x?x', 30);
	set('xo?x?x?o', 31);
	set('xoxoxoxo', 32);
	set('ooxoxooo', 33);
	set('xoooooxo', 34);
	// Row 8
	set('?x?oxoxo', 35);
	set('?x?oxooo', 36);
	set('?x?oooxo', 37);
	set('?oooxo?x', 38);
	set('oo?x?oxo', 39);
	// Row 9
	set('xoxo?x?o', 40);
	set('ooxo?x?o', 41);
	set('xooo?x?o', 42);
	set('?oxooo?x', 43);
	set('xo?x?ooo', 44);
	// Row 10
	// 45 is empty
	set('ooxoxoxo', 46);
	set('xoooxoxo', 47);
	set('xoxoooxo', 48);
	set('xoxoxooo', 49);
	
	return map;
})();

var processAutotile = function(collision)
{
	var height = collision.length;
	var width = collision[0].length;
	
	var invalid = function(x, y)
	{
		return (y < 0 || y > height || x < 0 || x > width)
	};
	
	var get = function(x, y)
	{
		if (invalid(x, y))
		{
			return 0;
		}
		
		return collision[y][x];
	};
	
	var set = function(x, y, value)
	{
		if (invalid(x, y))
		{
			return;
		}
		
		collision[y][x] = value;
	};
	
	var filled = function(x, y)
	{
		return (get(x, y) > 0);
	};
	
	for (var y = 0; y < height; ++y)
	{
		for (var x = 0; x < width; ++x)
		{
			if (get(x, y) == 8)
			{
				var value = 0;
				
				value += (filled(x - 1, y - 1) ?   1 : 0);
				value += (filled(x    , y - 1) ?   2 : 0);
				value += (filled(x + 1, y - 1) ?   4 : 0);
				value += (filled(x + 1, y    ) ?   8 : 0);
				value += (filled(x + 1, y + 1) ?  16 : 0);
				value += (filled(x    , y + 1) ?  32 : 0);
				value += (filled(x - 1, y + 1) ?  64 : 0);
				value += (filled(x - 1, y    ) ? 128 : 0);
				
				set(x, y, tiles[value]);
			}
		}
	}
};

var manipulate = function(filename, autotile)
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
					if (collision[y][x] > 0)
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
			
			bounds.top -= margin;
			bounds.right += margin + 1;
			bounds.bottom += margin + 1;
			bounds.left -= margin;
			
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
			
			if (autotile)
			{
				processAutotile(collision);
			}
			
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
			//fs.writeFile(path.join(filename, '..', 'output.oel'), xml, function(error)
			{
				if (error)
				{
					throw error;
				}
				
				console.log('Processed map: ' + filename.replace(mapsPath, '').replace(/\\/g, '/').slice(1, -4));
				--fileCount;
				
				if (fileCount <= 0)
				{
					report();
				}
			});
		});
	});
};

var walk = function(filename, autotile)
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
					walk(currentPath, autotile);
				}
				else if (currentPath.slice(-4) === '.oel')
				{
					manipulate(currentPath, autotile);
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
	
	margin = parseInt(args['--margin']);
	mapsPath = path.join(basepath, '/assets/maps');
	var filename;
	
	var autotile = args['--autotile'];
	
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
			walk(filename, autotile);
		}
		else
		{
			manipulate(filename, autotile);
		}
	});
};
