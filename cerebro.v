// ISC License
//
// Copyright (c) 2019 - 2020, Enrico Lefass
//
// Permission to use, copy, modify, and/or distribute this software for any
// purpose with or without fee is hereby granted, provided that the above
// copyright notice and this permission notice appear in all copies.
//
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
// WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
// ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
// ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
// OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
// import encoding.binary
import base
import image.farbfeld
import json
import os
import time

// import ui

// This is mainly for testing the methods.v file and most of the content
// will be transferred to methods_test.v in the future.
fn main() {
	app_version_msg := 'cerebro version ' + base.app_version +
		' using v implementation of farbfeld ' + farbfeld.get_version() + '\n'

	// TODO
	// user interaction for opening the file
	// use an argument from command line
	json_path := '..' + os.path_separator + 'cerebro_tst' + os.path_separator + '3L' +
		os.path_separator + 'cerebro.json'

	cerebro_file := os.read_file(os.real_path(json_path)) or {
		eprintln('failed to load JSON file')
		return
	}

	mut cerebro := json.decode(base.Cerebro, cerebro_file) or {
		eprintln('failed to decode JSON file')
		return
	}

	wlcm_mssg := 'Loading brain ' + cerebro.name + ' (mapped with cerebro version ' +
		cerebro.version + '):\n'

	println(app_version_msg)
	println(wlcm_mssg)
	println('Begin to analyze brain...')

	for neuron in cerebro.neurons {
		print(neuron.id)
		println(' ' + neuron.name + ' (type: ${neuron.type_id})')
	}

	println('\nAdding new neurons to ' + cerebro.name + ':')

	mut neuron_guard := false

	for neuron in cerebro.neurons {
		neuron_guard = (neuron.id > 4)

		if neuron_guard {
			println('Adding new neuron not possible - they do exist already.')
			println('Instead will forget neuron with id 5...')
			cerebro.forget_neuron(u64(5))
			break
		}
	}

	if !neuron_guard {
		cerebro.create_neuron('cerebro implementation', '', u64(3), 'An implemenation of cerebro in v.',
			'e:\/Users\/Enrico Lefass\/Documents\/tenebris\/cerebro\/', .directory, base.Data{''},
			[base.Link{u64(3)}])

		println('Added neuron "' + 'cerebro implementation' + '" to cerebro "' + cerebro.name + '".')
	}

	println('\nNow sum up all neurons with term "' + 'cerebro' +
		'" in its name or description field.')

	rxn := cerebro.get_neuron_by_string('(cerebro)', true, false, true) or { []base.Neuron{} }

	rxn_sum := rxn.len

	println('Number of neurons with "' + 'implement' + '" in its name field: ${rxn_sum}')

	cls_mssg := '\nSaving brain ' + cerebro.name + ' on ' + time.now().ddmmy() + ' at ' +
		time.now().hhmmss() + '...\n'

	println(cls_mssg)

	os.write_file(os.real_path(json_path), json.encode(cerebro))
	/*
	println("Farbfeld image testing...")

  ff_hdr := farbfeld.read_img('e:\\Users\\Enrico Lefass\\Downloads\\fortnite_john_wick_3840x1080.ff').header

  hdr_msg :=  'farbfeld header data:'
          +   '\n  image type: '
          +   ff_hdr.img_type
          +   '\n  name:       '
          +   ff_hdr.img_name
          +   '\n  location:   '
          +   ff_hdr.img_path
          +   '\n  dimensions: '
          +   ff_hdr.width.str()
          +   'x'
          +   ff_hdr.height.str()
          +   '\n  size:       '
          +   ff_hdr.img_size.str()
          +   ' byte(s) uncompressed\n'

  println(hdr_msg)

  println('create farbfeld test image data...')

  mut img_data  :=  []byte{}
  mut px_red    :=  [byte(0), byte(0)]
  mut px_green  :=  [byte(0), byte(0)]
  mut px_blue   :=  [byte(0), byte(0)]
  mut px_alpha  :=  [byte(0), byte(0)]

  for p := 0; p < 3840*1080; p++ {
    binary.big_endian_put_u16(mut px_red,   u16(80))
    binary.big_endian_put_u16(mut px_green, u16(120))
    binary.big_endian_put_u16(mut px_blue,  u16(160))
    binary.big_endian_put_u16(mut px_alpha, u16(20))

    img_data  <<  px_red
    img_data  <<  px_green
    img_data  <<  px_blue
    img_data  <<  px_alpha
  }

  hdr_data := farbfeld.Header{
                              width:    3840
                              height:   1080
                              img_name: 'fortnite_john_wick_3840x1080_test'
                              img_path: 'e:\\Users\\Enrico Lefass\\Downloads'
                              img_type: 'ff'
              }

  println('writing ' + hdr_data.img_name + '.' + hdr_data.img_type + '...')

  farbfeld.write_img(farbfeld.Image{header: hdr_data, data: img_data})
	*/
	println(time.now().get_fmt_str(.dot, .hhmmss24, .ddmmyy))
}
