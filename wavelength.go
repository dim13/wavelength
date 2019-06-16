// Package wavelength implements approximate RGB values for visible wavelengths
package wavelength

import (
	"image/color"
	"math"
)

// Convert wavelength in range from 380nm to 780nm to RGB value
func Convert(wl, gamma float64) color.Color {
	if gamma == 0.0 {
		gamma = 1.0
	}
	var r, g, b float64
	switch {
	case wl >= 380.0 && wl <= 440.0:
		r, g, b = (440.0-wl)/(440.0-380.0), 0.0, 1.0
	case wl > 440.0 && wl <= 490.0:
		r, g, b = 0.0, (wl-440.0)/(490.0-440.0), 1.0
	case wl > 490.0 && wl <= 510.0:
		r, g, b = 0.0, 1.0, (510.0-wl)/(510.0-490.0)
	case wl > 510.0 && wl <= 580.0:
		r, g, b = (wl-510.0)/(580.0-510.0), 1.0, 0.0
	case wl > 580.0 && wl <= 645.0:
		r, g, b = 1.0, (645.0-wl)/(645.0-580.0), 0.0
	case wl > 645.0 && wl <= 780.0:
		r, g, b = 1.0, 0.0, 0.0
	}
	// let the intensity fall off near the vision limits
	var sss float64
	switch {
	case wl > 700.0:
		sss = 0.3 + 0.7*(780.0-wl)/(780.0-700.0)
	case wl < 420.0:
		sss = 0.3 + 0.7*(wl-380.0)/(420.0-380.0)
	default:
		sss = 1.0
	}
	// gamma adjust
	return color.RGBA{
		R: uint8(0xff * math.Pow(sss*r, gamma)),
		G: uint8(0xff * math.Pow(sss*g, gamma)),
		B: uint8(0xff * math.Pow(sss*b, gamma)),
		A: 0xff,
	}
}
