-- Trick or Treat mod by mootpoint
-- Copyright (C) 2016 Tucker 'mootpoint' Bamberg
-- Foz name here
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

local distribution = {1, 1, 1, 2, 2, 3}

minetest.register_tool('trick_or_treat:candy_bucket', {
		description = 'Candy Bucket',
		inventory_image = 'trick_or_treat_candy_bucket.png',
		wield_image     = 'trick_or_treat_candy_bucket.png^[transformR270]',
})

if wieldview then
	wieldview.transform['trick_or_treat:candy_bucket']='R180'
end

minetest.register_craft({
	output = 'trick_or_treat:candy_bucket',
	recipe = {
		{'group:stick'},
		{'farming:pumpkin_face'},
	}
})

minetest.register_node('trick_or_treat:treat_box', {
		description = 'Box that gives candy when punched',
		tiles = {'trick_or_treat_treat_box.png'},
		groups = {oddly_breakable_by_hand = 1, not_in_creative_inventory = 1},
		on_punch = function(pos, node, puncher, pointed_thing)
			local wielded_item = puncher:get_wielded_item():get_name()
			if wielded_item == 'trick_or_treat:candy_bucket' then

				local meta = minetest.get_meta(pos)
				local last = meta:get_string('last_user')
				local name = puncher:get_player_name()

				if last ~= name then
					meta:set_string('last_user',name)

					-- Check the date.
					local now = os.time()
					local halloween = {
						year = os.date('*t',now).year,
						month = 10,
						day = 31,
					}

					if math.abs(now - os.time(halloween)) > 259200 then -- 3 days
						minetest.chat_send_player(name,
							'Its not close enough to Halloween to be trick or treating.')
						return
					end

					-- It's almost Halloween so give them candy.
					local item = candy[math.random(1,#candy)]
					local amount = distribution[math.random(1, #distribution)]

					local inv = puncher:get_inventory()
					if inv:room_for_item('main', item..' '..amount) then
						puncher:get_inventory():add_item('main', item..' '..amount)
						minetest.log('action', 'Trick or Treat: Gave '..name..' '..amount..
							' '..item..' at '..minetest.pos_to_string(pos))
					else
						minetest.chat_send_player(name,
							'No Candy for you!!! Your inventory is full')
					end
				else
					minetest.chat_send_player(name,
						'You have already stopped here. Try again later.')
				end
			end
		end
})
