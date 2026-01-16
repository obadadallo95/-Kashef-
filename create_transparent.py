import zlib
import struct

def make_png(width, height):
    # PNG Header
    header = b'\x89PNG\r\n\x1a\n'
    
    # IHDR Chunk
    # Width, Height, Bit depth (8), Color type (6=RGBA), Compression (0), Filter (0), Interlace (0)
    # Correct format: ! (network endian), I (uint32), I (uint32), B (uchar), B, B, B, B
    ihdr_data = struct.pack('!IIBBBBB', width, height, 8, 6, 0, 0, 0)
    ihdr = struct.pack('!I', len(ihdr_data)) + b'IHDR' + ihdr_data + struct.pack('!I', zlib.crc32(b'IHDR' + ihdr_data))
    
    # IDAT Chunk (Image Data)
    # Scanline: Filter byte (0) + 4 bytes * width
    line_len = 1 + 4 * width
    # Raw data: height * scanline
    raw_data = b'\x00' * (line_len * height)
    compressed_data = zlib.compress(raw_data)
    idat = struct.pack('!I', len(compressed_data)) + b'IDAT' + compressed_data + struct.pack('!I', zlib.crc32(b'IDAT' + compressed_data))
    
    # IEND Chunk
    iend = struct.pack('!I', 0) + b'IEND' + struct.pack('!I', zlib.crc32(b'IEND'))
    
    return header + ihdr + idat + iend

with open('assets/images/transparent.png', 'wb') as f:
    f.write(make_png(64, 64))

print("Created 64x64 transparent PNG")
