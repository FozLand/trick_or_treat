-- Trick or Treat mod by mootpoint
-- Copyright (C) 2016 Tucker 'mootpoint' Bamberg
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

local candy = {
	'mtcandy:sugar_block',
	'mtcandy:caramel',
	'mtcandy:crosscandy',
	'mtcandy:candyrec_bluecyan',
	'mtcandy:candyrec_magenta',
	'mtcandy:candyrec_orange',
	'mtcandy:candyrec_yellow',
	'mtcandy:dotted_green',
	'mtcandy:dotted_red',
	'mtcandy:dotted_pink',
	'mtcandy:dotted_orange',
	'mtcandy:dotted_yellow',
	'mtcandy:peppermint',
	'mtcandy:peppermint_red',
	'mtcandy:peppermint_cyan_top',
	'mtcandy:peppermint_green_top',
	'mtcandy:peppermint_magenta_top',
	'mtcandy:peppermint_orange_top',
	'mtcandy:peppermint_yellow_top',
	'mtcandy:spiral_blue',
	'mtcandy:spiral_purple',
	'mtcandy:spiral_yellow',
	'mtcandy:striped_pink_brown',
	'mtcandy:striped_pink_white',
	'mtcandy:striped_pink_yellow',
	'mtcandy:striped_purple_green',
	'mtcandy:striped_lime_green',
	'mtcandy:milk_choco',
	'mtcandy:white_choco',
	'mtcandy:orange',
	'mtcandy:pcorn_side',
	'mtcandy:daisy',
	'mtcandy:heart_candy',
	'mtcandy:emenems'
}

minetest.register_craftitem('trick_or_treat:candy_bucket', {
		description = 'Candy Bucket',
		stack_max = 1,
		inventory_image = 'trick_or_treat_candy_bucket.png',
})

minetest.register_node('trick_or_treat:treat_box', {
		description = 'Box that gives candy when punched',
		tiles = {'trick_or_treat_treat_box.png'},
		groups = {oddly_breakable_by_hand = 1, not_in_creative_inventory = 1},
})

minetest.register_on_punchnode(function(pos, node, puncher, pointed_thing)
		if puncher:get_wielded_item():get_name() == "trick_or_treat:candy_bucket"
		   and node.name == "trick_or_treat:treat_box" then
			local choice = math.random(1, 34)
			local amount = math.random(1, 5)
			local inv = puncher:get_inventory()
			local name = candy[tonumber(choice)]
		if inv:room_for_item( 'main', name..' '..amount ) then
			puncher:get_inventory():add_item("main", name..' '..amount) return
		else
			minetest.chat_send_player(puncher:get_player_name(),
				'No Candy for you!!! Your inventory was full')
		end
	end
end)
