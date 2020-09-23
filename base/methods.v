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

// This module provides the base functionality of cerebro.

import regex
import time

// get_new_neuron_id returns a new unique id for the given Cerebro as u64.
fn get_new_neuron_id(c Cerebro) u64 {
  mut id := u64(0)

  for neuron in c.neurons {
    if neuron.id > id {
      id = u64(neuron.id)
    }
  }

  return id + 1
}

// create_neuron creates a new Neuron within the given Cerebro.
pub fn (mut c Cerebro) create_neuron(n_name, n_icon string, n_depth u64, n_desc, n_src string, n_type_id TypeID, n_content Data, n_links []Link) {
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

// forget_neuron marks the Neuron with the given id (as u64) as deceased and
// writes the current time when it forgot the Neuron in the fields modified
// and visited.
pub fn (mut c Cerebro) forget_neuron(id u64) {
  for i, n in c.neurons {
    if n.id == id {
      n_time := time.now().get_fmt_str(.dot, .hhmmss24, .ddmmyyyy)
      
      c.neurons[i].deceased = true
      c.neurons[i].modified = n_time
      c.neurons[i].visited  = n_time
    }
  }
}

// get_neuron_by_id returns the Neuron with the given id (as u64) as Option
// type.
pub fn (c Cerebro) get_neuron_by_id(id u64) ?Neuron {
  for n in c.neurons {
    if n.id == id {
      return n
    }
  }
  return error('A neuron with id $id was not found!')
}

// get_neuron_by_type_id returns an array of Neurons which matches the given
// TypeID as an Option type.
pub fn (c Cerebro) get_neuron_by_type_id(type_id TypeID) ?[]Neuron {
  mut neurons := []Neuron{}

  for n in c.neurons {
    if n.type_id == type_id {
      neurons << n
    }
  }

  if neurons.len == 0 {
    return error('A neuron with the type_id $type_id was not found!')
  } else {
    return neurons
  }
}

// get_neuron_by_string returns an array of Neurons which matches the given
// string (with additional options) as an Option type.
pub fn (c Cerebro) get_neuron_by_string(str string, cs, bn, is_rx_str bool) ?[]Neuron {
  mut neurons     := []Neuron{}
  mut rx_pattern  := ''
  mut cmp_str     := ''

  if is_rx_str {
    rx_pattern = str
  }

  if !is_rx_str && cs {
    rx_pattern = '(' + str + ')'
  }

  if !is_rx_str && !cs {
    rx_pattern = '(' + str.to_lower() + ')'
  }

  mut rx := regex.regex_opt(rx_pattern)?

  for n in c.neurons {
    if bn && cs {
      cmp_str = n.name
    }

    if bn && !cs {
      cmp_str = n.name.to_lower()
    }

    if !bn && cs {
      cmp_str = n.name + '|' + n.description
    }

    if !bn && !cs {
      cmp_str = n.name.to_lower() + '|' + n.description.to_lower()
    }

    start, end := rx.find(cmp_str)

    if start >= 0 && end > 0 {
      neurons << n
    }
  }

  if neurons.len == 0 {
    return error('A neuron with the name $str was not found!')
  } else {
    return neurons
  }
}
