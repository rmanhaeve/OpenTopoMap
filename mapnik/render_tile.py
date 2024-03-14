import mapnik

mapfile = 'opentopomap.xml'
map_output = 'out.png'

m = mapnik.Map(10000, 10000)
mapnik.load_map(m, mapfile)
#center_x = 50.879202
#center_y = 4.701168
#bbox = mapnik.Envelope(mapnik.Coord(center_x-50000, center_y-50000), mapnik.Coord(center_x+5000, center_y+5000))
bbox = mapnik.Envelope(mapnik.Coord(4.6347, 50.8510), mapnik.Coord(4.7804, 50.9021))
#bbox = mapnik.Envelope(mapnik.Coord(50.8510,4.6347), mapnik.Coord(50.9021,4.7804))
#m.zoom_to_box(bbox)
m.zoom_all()
#m.zoom(1/3)
mapnik.render_to_file(m, map_output)
