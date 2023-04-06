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
module farbfeld

import encoding.binary
import os

// write_header Writes the header data with given dimension.
// @param       file (os.File), width (u32), height (u32)
// @return      void
// @example     none provided
fn write_header(mut f os.File, w u32, h u32) {
	mut w_byte := [byte(0), byte(0), byte(0), byte(0)]
	mut h_byte := [byte(0), byte(0), byte(0), byte(0)]

	binary.big_endian_put_u32(mut w_byte, w)
	binary.big_endian_put_u32(mut h_byte, h)

	f.write_bytes_at(mv.data, 8, 0)
	f.write_bytes_at(w_byte.data, 4, 8)
	f.write_bytes_at(h_byte.data, 4, 12)
}

// get_version  Returns the version number of supported farbfeld standard.
// @param       none
// @return      string
// @example     '4'
pub fn get_version() string {
	return version
}

// read_img Returns an farbfeld image structure for given file name only
//          if it is a farbfeld file otherwise it returns a farbfeld image
//          structure with a header with zero width value, zero height value
//          and no imgage data (a single zero byte).
// @param   file name (string)
// @return  farbfeld image structure (Image)
pub fn read_img(f string) Image {
	rp := os.real_path(f)

	mut ff := os.open(rp) or {
		eprintln('could not open file ${f}')
		return Image{}
	}

	hdr_data := read_header(ff, rp)

	if hdr_data.width == u32(0) {
		eprintln('${f} is not a farbfeld file')

		ff.close()

		return Image{
			header: hdr_data
			data: [byte(0)].repeat(1)
		}
	}

	img_data := ff.read_bytes_at(os.file_size(rp) - 16, 16)

	ff.close()

	return Image{
		header: hdr_data
		data: img_data
	}
}

// read_header  Tries to read the farbfeld header structure from a given
//              file.
//              Returns a Header with zero width and height if file exists
//              but is not a farbfeld image.
// @param       file name (string)
// @return      farbfeld header struct (Header)
// @example     none provided
fn read_header(ff os.File, rp string) Header {
	mut w := u32(0)
	mut h := u32(0)

	t := os.file_ext(rp)

	if mv.str() == ff.read_bytes(8).str() {
		w = binary.big_endian_u32(ff.read_bytes_at(4, 8))
		h = binary.big_endian_u32(ff.read_bytes_at(4, 12))
	}

	return Header{
		width: w
		height: h
		img_name: os.file_name(rp)
		img_path: os.dir(rp)
		img_type: t[1..]
		img_size: u64(os.file_size(rp))
	}
}

// write_img  Writes a farbfeld image with given farbfeld image structure.
// @param     image struct (farbfeld.Image)
// @return    void
// @example   none provided
pub fn write_img(img Image) {
	s := u64(img.header.width * img.header.height * u32(8))

	n := img.header.img_name

	mut f := img.header.img_path + os.path_separator

	if n[n.len - 3..] != '.' + img.header.img_type {
		f = f + n + '.' + img.header.img_type
	} else {
		f = f + n
	}

	mut ff := os.create(os.real_path(f)) or {
		eprintln('failed to create file ${f}')
		return
	}

	w := img.header.width

	h := img.header.height

	write_header(mut ff, w, h)

	if u64(img.data.len) == s {
		ff.write_bytes_at(img.data.data, img.data.len, 16)
	} else {
		if u64(img.data.len) < s {
			eprintln('less data (${img.data.len}) for given dimension ${w} x ${h}')
		} else {
			eprintln('more data (${img.data.len}) for given dimension ${w} x ${h}')
		}
	}

	ff.close()
}
