import xdrlib
from io import BytesIO
import struct
import random
import math

def xdr_pack_bytes( buf: list[bytes]):
    b_out = BytesIO()
    for item in buf:
        n = len(item)
        b_out.write(struct.pack('>L', n))
        data = item[:n]
        n = math.ceil(n/4)*4
        data = data + (n - len(data)) * b'\0'
        b_out.write(data)
    
    return b_out.getvalue()

def normal_pack_bytes( buf: list[bytes]):
    packer = xdrlib.Packer()
    for item in buf:
        packer.pack_bytes(item)
    
    return bytearray(packer.get_buffer())

def create_test_list(num_tests: int = 100):
    test_list = []

    # Number of tests
    for _ in range(num_tests):
        test = []
        # number of entries in the tests
        for _ in range(random.randint(1,100)):
            # Add a random number of bytes to the test
            test.append(random.randbytes(random.randint(1,100)))
        test_list.append(test)
    return test_list

def main():
    test_list = create_test_list(10000)

    print("Starting Tests...")
    for test in test_list:
        buffer_a = normal_pack_bytes(test)
        buffer_b = xdr_pack_bytes(test)
        print(type(buffer_a))
        assert buffer_a == buffer_b
    print("All Tests Passed!")







# list_of_buffers = []
# for _ in range(100):
#     num_entries = random.randint(1,10)
#     l = []
#     for _ in range(num_entries):
#         num_bytes = random.randint(1, 100)  # Generate a random number of bytes between 1 and 10
#         s = ""
#         for _ in range(num_bytes):
#             random_char = random.choice(string.ascii_letters)  # a rando
#             s+=random_char
#         l.append(bytes(s, 'utf-8'))
#     list_of_buffers.append(l)

# for bu in list_of_buffers:
#     print(bu)
#     packer = xdrlib.Packer()
#     for item in bu:
#         packer.pack_bytes(bu)
    
#     a = packer.get_buffer()
#     b = xdr_pack_bytes(bu)
    
#     # assert a == b
#     # print(a)
    # print(b)



if __name__ == "__main__":
    main()