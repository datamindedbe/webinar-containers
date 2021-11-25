import unittest

from src.main import parse_args


class MainTest(unittest.TestCase):
    def test_parse_args_no_arguments(self):
        with self.assertRaises(SystemExit) as cm:
            parse_args()
        self.assertEqual(cm.exception.code, 2)
