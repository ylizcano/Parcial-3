"""
 * Fecha: 9-Noviembre-2022
 * Autor: Yeison Steven Lizcano Valderrama
 * Materia: Parallel and Distributed Computing
 * Tema: Fichero para la creación del objeto Compartido
"""

from distutils.core import setup, Extension
from Cython.Build import cythonize

exts = (cythonize("AlgoritmoGenetico_C.pyx", annotate=True))

setup(ext_modules = exts)
