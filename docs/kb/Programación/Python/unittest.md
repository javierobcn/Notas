# unittest
```py
import unittest

class TestBasica(unittest.TestCase):

    def test_es_menor_que(self):
        self.assertTrue(2 < 3)

class TestCadenasCaracteres(unittest.TestCase):
    
    def test_igualdad_cadenas(self):
        self.assertEqual('i' * 5 ,'iiiii')
    
    def test_es_mayusculas(self):
        self.assertEqual('iiii'.upper()) == "IIII"

if __name__ == "__main__":
    unittest.main()

```
