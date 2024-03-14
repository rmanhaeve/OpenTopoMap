import mapnik

mapfile = 'opentopomap.xml'
map_output = 'out.png'

m = mapnik.Map(1000, 1000)
mapnik.load_map(m, mapfile)
bbox = 496840.6839,6579699.3948,549123.6112,6614860.4278
bbox = 673689.467321-5000,674925.873282-5000,673689.467321+5000,674925.873282+5000


bbox = mapnik.Envelope(mapnik.Coord(*bbox[:2]), mapnik.Coord(*bbox[2:]))
#bbox = mapnik.Envelope(mapnik.Coord(4.6347, 50.8510), mapnik.Coord(4.7804, 50.9021))
#bbox = mapnik.Envelope(mapnik.Coord(50.8510,4.6347), mapnik.Coord(50.9021,4.7804))

m.zoom_to_box(bbox)
#m.zoom_all()
#m.zoom(10)
mapnik.render_to_file(m, map_output)
