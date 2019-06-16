package wavelength

import (
	"fmt"
	"image/color"
	"testing"
)

func TestConvert(t *testing.T) {
	testCases := []struct {
		wl float64
		c  color.Color
	}{
		{wl: 380.0, c: color.RGBA{0x4c, 0x00, 0x4c, 0xff}},
		{wl: 400.0, c: color.RGBA{0x6e, 0x00, 0xa5, 0xff}},
		{wl: 430.0, c: color.RGBA{0x2a, 0x00, 0xff, 0xff}}, // P11
		{wl: 440.0, c: color.RGBA{0x00, 0x00, 0xff, 0xff}},
		{wl: 460.0, c: color.RGBA{0x00, 0x66, 0xff, 0xff}}, // P11
		{wl: 490.0, c: color.RGBA{0x00, 0xff, 0xff, 0xff}},
		{wl: 510.0, c: color.RGBA{0x00, 0xff, 0x00, 0xff}},
		{wl: 525.0, c: color.RGBA{0x36, 0xff, 0x00, 0xff}}, // P1
		{wl: 580.0, c: color.RGBA{0xff, 0xff, 0x00, 0xff}},
		{wl: 602.0, c: color.RGBA{0xff, 0xa8, 0x00, 0xff}}, // P3
		{wl: 645.0, c: color.RGBA{0xff, 0x00, 0x00, 0xff}},
		{wl: 780.0, c: color.RGBA{0x4c, 0x00, 0x00, 0xff}},
	}
	for _, tc := range testCases {
		t.Run(fmt.Sprintf("%5.1fnm", tc.wl), func(t *testing.T) {
			c := Convert(tc.wl, 0.0)
			if c != tc.c {
				t.Errorf("got %x, want %x", c, tc.c)
			}
		})
	}
}
