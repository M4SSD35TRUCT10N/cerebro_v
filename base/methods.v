// ISC License
// 
// Copyright (c) 2020, Enrico Lefass
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

import time

fn get_new_neuron_id(c Cerebro) u64 {
  mut id := u64(0)

  for neuron in c.neurons {
    if neuron.id > id {
      id = u64(neuron.id)
    }
  }

  return id + 1
}

pub fn (mut c Cerebro) create_neuron(n_name, n_icon string, n_depth u64, n_desc, n_src, n_type_id string, n_content Data, n_links []Link) {
  n_time := time.now().get_fmt_str(.dot, .hhmmss24, .ddmmyyyy)

  c.neurons << Neuron {
    name:         n_name
    icon:         n_icon
    depth:        n_depth
    id:           get_new_neuron_id(c)
    description:  n_desc
    created:      n_time
    modified:     n_time
    visited:      n_time
    source:       n_src
    type_id:      n_type_id
    deceased:     false
    content:      n_content
    links:        n_links
  }
}

pub fn (mut c Cerebro) forget_neuron(n_id u64) {
  for i, n in c.neurons {
    if n.id == n_id {
      n_time := time.now().get_fmt_str(.dot, .hhmmss24, .ddmmyyyy)
      
      c.neurons[i].deceased = true
      c.neurons[i].modified = n_time
      c.neurons[i].visited  = n_time
    }
  }
}

pub fn (c Cerebro) get_neuron_by_id(id u64) ?Neuron {
  for n in c.neurons {
    if n.id == id {
      return n
    }
  }
  return error('A neuron with id $id was not found!')
}

pub fn (c Cerebro) get_neuron_by_name(name string) ?[]Neuron {
  mut neurons := []Neuron{}

  for n in c.neurons {
    if n.name == name {
      neurons << n
    }
  }

  if neurons.len == 0 {
    return error('A neuron with the name $name was not found!')
  } else {
    return neurons
  }
}
