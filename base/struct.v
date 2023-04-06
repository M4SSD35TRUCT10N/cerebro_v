// ISC License
//
// Copyright (c) 2019, Enrico Lefass
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
module base

pub struct Cerebro {
pub mut:
	version     string
	name        string
	icon        string
	description string
	created     string
	modified    string
	visited     string
	source      string
	type_id     string
	deceased    bool
	neurons     []Neuron
}

pub struct Neuron {
pub mut:
	name        string
	icon        string
	depth       u64
	id          u64
	description string
	created     string
	modified    string
	visited     string
	source      string
	type_id     string
	deceased    bool
	content     Data
	links       []Link
}

pub struct Data {
pub mut:
	data string
}

pub struct Link {
pub mut:
	id u64
}
