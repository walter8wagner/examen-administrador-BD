#!/usr/bin/env python
import os 
import sys
import tkinter as tk
from tkinter import ttk, PhotoImage, messagebox as mb
import json
import customtkinter as ctk
from PIL import Image, ImageTk
import pyodbc

# configuraciones para la ventana
def configuraciones():
	with open("settings.json","r") as fileConfig:
		data = json.load(fileConfig)
	return data

# conexion al servidor SQL en SqlServer
try: 

	con = pyodbc.connect(
			 'DRIVER={SQL Server}; ' +
			 'Server=DESKTOP-HLK011R\\MSSQLSERVER02;'+
			 'Database=DanielPromociones;'+
			 'Trusted_Connection=True'
		)

	con.autocommit = True

	cursor = con.cursor()
except Exception as e:
	print ("Mensaje de error " , e)



class MainApp(tk.Frame):
	
	def __init__(self, parent, dataConfig, *args, **kwargs):
		super().__init__(parent, *args, **kwargs)
		self.dataConfig = dataConfig
		self.parent = parent
		self.ancho = self.dataConfig["ancho_ventana"]
		self.alto = self.dataConfig["alto_ventana"]

		self.parent.geometry(f"{self.ancho}x{self.alto}+300+50")
		self.parent.title("Menu")

		self.parent.configure(bg="lightblue")  # Cambia el color de fondo a lightblue


		self.panelPaneles = ctk.CTkFrame(self.parent)
		self.panelPaneles.pack(side="left", fill = "y")


		self.panelEntradaFrame = ctk.CTkFrame(self.panelPaneles)
		self.panelEntradaFrame.configure(fg_color = dataConfig["color_fondo"])
		self.panelEntradaFrame.pack(fill = "both", expand = True)

		self.panelBotonesFrame = ctk.CTkFrame(self.panelPaneles)
		self.panelBotonesFrame.configure(fg_color = dataConfig["color_fondo2"])
		self.panelBotonesFrame.pack( fill = "both", expand = True)


		# ------- formulario

		self.nombre_promociones = ctk.CTkLabel(self.panelEntradaFrame, text = "Nombre Promociones")
		self.nombre_promociones_text = ctk.CTkTextbox(self.panelEntradaFrame,  height = 1)

		self.descripcion_promociones = ctk.CTkLabel(self.panelEntradaFrame, text = "Descripcion de promociones")
		self.descripcion_promociones_text = ctk.CTkTextbox(self.panelEntradaFrame,  height = 1)

		self.estado_promociones = ctk.CTkLabel(self.panelEntradaFrame, text = "Estado de Promocion")
		self.estado_promociones_text = ctk.CTkTextbox(self.panelEntradaFrame, height = 1)

		self.precio_promociones = ctk.CTkLabel(self.panelEntradaFrame, text="Precio")
		self.precio_promociones_text = ctk.CTkTextbox(self.panelEntradaFrame, height=1)

		self.cantidad_promociones = ctk.CTkLabel(self.panelEntradaFrame, text="Cantidad")
		self.cantidad_promociones_text = ctk.CTkTextbox(self.panelEntradaFrame, height=1)

		self.entradas = (self.nombre_promociones, self.nombre_promociones_text, self.descripcion_promociones, self.descripcion_promociones_text,
						 self.estado_promociones, self.estado_promociones_text, self.precio_promociones, self.precio_promociones_text,
						 self.cantidad_promociones, self.cantidad_promociones_text)

		
		for entrada in self.entradas:
			entrada.configure( font = ("Comic Sans MS", 13))
			entrada.pack(padx= (10,10))





		self.mostrar_boton = ctk.CTkButton(self.panelBotonesFrame, text = "Recargar", command = self.function_mostrar_boton, fg_color=dataConfig["color_principal"])

		self.guardar_boton = ctk.CTkButton(self.panelBotonesFrame, text = "Crear nuevo", command = self.function_guardar_boton, fg_color=dataConfig["color_principal"])

		self.eliminar_boton = ctk.CTkButton(self.panelBotonesFrame, text = "Eliminar", command = self.function_eliminar_boton, fg_color=dataConfig["color_principal"])

		self.modificar_boton = ctk.CTkButton(self.panelBotonesFrame, text = "Modificar", command = self.function_modificar_boton, fg_color=dataConfig["color_principal"])

		self.limpiesa_boton = ctk.CTkButton(self.panelBotonesFrame, text = "Borrar todo", command = self.fuction_limpiar_boton, fg_color = "#B2533E")

		self.salir_boton = ctk.CTkButton(self.panelBotonesFrame, text = "Salir", command = self.fuction_salir_boton, fg_color= "#186F65")


		self.botones = (self.mostrar_boton, self.guardar_boton, self.modificar_boton, self.eliminar_boton, self.limpiesa_boton, self.salir_boton)
		nFila = 20
		for boton in self.botones:
			boton.configure(text_color=dataConfig["color_acento"])
			#boton.grid(row=nFila, padx=(10,10), pady = (5,5))
			boton.place(x = 20, y = nFila)
			nFila += 40


		self.mensaje_busqueda = tk.Label(self.parent, text = "Ingresa alguna palabra y pulsa [ENTER] para buscar", justify = "left", bg = "white", fg = "black", font = ("Comic Sans MS","9")) 
		self.mensaje_busqueda.pack(side="top", anchor = "nw", padx = (0,5), fill = "x")

		# Marco para la barra de búsqueda y botón
		self.frame_busqueda = ctk.CTkFrame(self.parent)
		self.frame_busqueda.pack(fill="x", padx=5, pady=5)

		# Casilla de búsqueda
		self.casilla_busqueda = ctk.CTkTextbox(self.frame_busqueda, height=1, fg_color = "white", text_color = "black")
		self.casilla_busqueda.pack(side="left", fill="x", expand=True)
		self.casilla_busqueda.bind("<Return>", self.function_buscar_registro)

		# Imagen del botón de búsqueda
		imagen_boton = PhotoImage(file="lupa.png")
		imagen_boton = imagen_boton.subsample(20, 20)  # Redimensiona la imagen
		self.boton_busqueda = ctk.CTkButton(self.frame_busqueda, image=imagen_boton, text="Buscar", command = self.function_buscar_registro, fg_color = dataConfig["color_complementario2"] )
		self.boton_busqueda.pack(side="right", padx=(0, 5))

		# Tabla 
		self.tree = ttk.Treeview(self.parent)
		self.tree["columns"] = ("C_Nombre", "C_Descripcion", "C_Estado", "C_Precio", "C_Cantidad")
		
		self.tree.column("#0", width=int(self.parent.winfo_reqwidth() / 21) )
		self.tree.column("C_Nombre", width=int(self.parent.winfo_reqwidth() / 5) + 10)
		self.tree.column("C_Descripcion", width=int(self.parent.winfo_reqwidth() / 5))
		self.tree.column("C_Estado", width=int(self.parent.winfo_reqwidth() / 5 - 20) + 20)
		self.tree.column("C_Precio", width=int(self.parent.winfo_reqwidth() / 5 - 50))
		self.tree.column("C_Cantidad", width=int(self.parent.winfo_reqwidth() / 5 - 50))

		self.tree.heading("#0", text="ID's")
		self.tree.heading("C_Nombre", text="Nombre de Promocion")
		self.tree.heading("C_Descripcion", text="Descripcion")
		self.tree.heading("C_Estado", text="Estado de promocion")
		self.tree.heading("C_Precio", text="Precio")
		self.tree.heading("C_Cantidad", text="Cantidad")

		# Barra de desplazamiento vertical para la tabla
		scrollbar_y = tk.Scrollbar(self.parent, orient="vertical", command=self.tree.yview)
		self.tree.configure(yscrollcommand=scrollbar_y.set)

		self.tree.pack(side = "left", fill="both", expand=True)
		scrollbar_y.pack(fill="y", side="right")

		
		self.function_mostrar_boton()

		self.tree.bind("<ButtonRelease-1>", self.selecionar_datos)

		self.posicion_registro = None

	def selecionar_datos(self, datos):
		print("click")
		seleccion = self.tree.focus()
		datos = self.tree.item(seleccion)['values']
		print("datos seleccionados ", datos) 

		# Obtener los datos de los nuevos campos
		precio_obtenido = self.precio_promociones_text.get("1.0", tk.END)
		cantidad_obtenida = self.cantidad_promociones_text.get("1.0", tk.END)

		self.eliminar_contenido_casillas()

		try:
			# Insertar los datos en los campos existentes
			self.nombre_promociones_text.insert(tk.END, datos[0])
			self.descripcion_promociones_text.insert(tk.END, datos[1])
			self.estado_promociones_text.insert(tk.END, datos[2])

			# Insertar los datos en los nuevos campos
			self.precio_promociones_text.insert(tk.END, datos[3])
			self.cantidad_promociones_text.insert(tk.END, datos[4])
		except Exception as e: 
			print("no hay ningun registro seleccionado")

		self.posicion_registro = int(self.tree.index(seleccion) + 1)

	def eliminar_contenido_casillas(self):
		self.nombre_promociones_text.delete("1.0", tk.END)
		self.descripcion_promociones_text.delete("1.0", tk.END)   
		self.estado_promociones_text.delete("1.0", tk.END)
		self.precio_promociones_text.delete("1.0", tk.END)  # Eliminar contenido del campo precio
		self.cantidad_promociones_text.delete("1.0", tk.END)  # Eliminar contenido del campo cantidad
		self.casilla_busqueda.delete("1.0", tk.END)


	def insercionEnTablas(self, resultadoSQLServer):
		print("\n Insertando datos en la tabla ...")
		print("respuesta recibida: ", resultadoSQLServer)
		nid = 0
		for nombreP in resultadoSQLServer:
			nid = nid + 1
			# Agregar los nuevos campos precio y cantidad a la tupla de valores
			self.tree.insert("", tk.END, text=nid, values=(nombreP[1], nombreP[2], ["activo" if nombreP[3] == "a" else "inactivo"], nombreP[4], nombreP[5]))
		pass

	def actualizacion_tree(self):
		# esta funcion lo que hace es limpiar los elementos de la tabla
		for item in self.tree.get_children():
			self.tree.delete(item)
		pass	

	def comunicacion(self, comandoInpt = None):
		print("\n Comando a enviar:", comandoInpt)

		cursor.execute("use DanielPromociones")

		cursor.execute(comandoInpt)

		rows = ""

		try: 
			try:
				rows = cursor.fetchall()
			except Exception as e:
				rows = cursor.fetchone()

		except pyodbc.ProgrammingError as error: 
			print("Error de server ", error)
			con.commit()

		finally:
			print("query enviado y recibido")

		return rows
		pass
	def function_mostrar_boton(self):
		print("\n Recargando datos ... ")
		self.actualizacion_tree()
		self.resultado = self.comunicacion("select * from promociones")
		self.insercionEnTablas(self.resultado)
		self.eliminar_contenido_casillas()
		pass

	def function_guardar_boton(self):
		print("\nGuardando datos...")

		# Lista de casillas de texto
		casillas = [self.nombre_promociones_text, self.descripcion_promociones_text]

		# Bandera para verificar si hay errores
		hay_error = False

		for casilla in casillas:
			if not casilla.get("1.0", tk.END).strip():  # Verificar si la casilla está vacía
				self.ventana_emergente("  Verifica que los casillas de entrada  ")
				hay_error = True
				break

		if not hay_error:
			estado = self.estado_promociones_text.get("1.0", tk.END).strip()
			precio = self.precio_promociones_text.get("1.0", tk.END).strip()  # Obtener el valor del campo precio
			cantidad = self.cantidad_promociones_text.get("1.0", tk.END).strip()  # Obtener el valor del campo cantidad

			if estado not in ("a", "i", "activo", "inactivo"):  # Verificar si el estado es válido
				self.ventana_emergente("  Debes ingresar un estado válido (a: activo, i: inactivo), \n sin los paréntesis ()")
			elif not precio or not cantidad:  # Verificar si los campos precio y cantidad están vacíos
				self.ventana_emergente("  Verifica que los casillas de entrada para precio y cantidad estén completas  ")
			else:
				try:
					# Insertar los datos en la base de datos
					self.comunicacion(f"INSERT INTO promociones (nombre_promociones, descripcion, precio, cantidad, estado) VALUES ('{self.nombre_promociones_text.get("1.0","end-1c")}', '{self.descripcion_promociones_text.get("1.0","end-1c")}', {float(precio)}, {int(cantidad)}, '{estado}')")
					self.actualizacion_tree()
					self.function_mostrar_boton()
					self.eliminar_contenido_casillas()
				except Exception as e:
					print("Ha ocurrido un error al guardar los datos:", e)

	def function_eliminar_boton(self):
		print("\n Eliminando registro ...")
		
		# Obtener el ID del registro a eliminar
		determinar_id_sql = self.posicion_registro
		# Obtener todos los registros
		respuesta_para_identificacion = self.comunicacion("select * from promociones")
		# Obtener el registro específico usando la posición del registro

		try:
			registro_a_eliminar = respuesta_para_identificacion[determinar_id_sql - 1]
			# Obtener el ID del registro específico
			id_registro = registro_a_eliminar[0]  # Suponiendo que el ID está en la primera columna
			# Eliminar el registro
			cursor.execute("delete from promociones where id_promociones = ?", (id_registro,))
			# Confirmar la transacción
			con.commit()
		except Exception as e:
			self.ventana_emergente("Al parecer no has seleccionado un registro ")

		# Actualizar el Treeview
		self.actualizacion_tree()
		# Mostrar los registros actualizados
		self.function_mostrar_boton()
		
		self.eliminar_contenido_casillas()
		pass


	def fuction_salir_boton(self):
		print("\n Saliendo del programa ... ")
		self.actualizacion_tree()
		self.function_mostrar_boton()
		sys.exit()
		pass

	def fuction_limpiar_boton(self):
		confirmacion = mb.askyesno(message="¿Desea continuar y eliminar todos los registros?", title="Vaciar base de datos")
		if confirmacion == True:
			print("\n Eliminando todos los registros ... ")
			self.comunicacion("delete promociones")

			self.actualizacion_tree()
			self.function_mostrar_boton()
		else:
			pass
		pass

	def function_buscar_registro(self, event = None):
		print("\n Buscando al registro ...")
		# Obtener el texto de la casilla de búsqueda
		valor_buscado = self.casilla_busqueda.get("1.0", tk.END).strip()

		# Realizar la consulta SQL para buscar registros que coincidan con el patrón
		cursor.execute("SELECT * FROM promociones WHERE nombre_promociones LIKE ?", f"%{valor_buscado}%")

		# Obtener el primer registro que coincide con el patrón
		try:
			buscado = cursor.fetchall()
		except: 
			buscado = cursor.fetchone()

		# Imprimir el resultado de la búsqueda
		print("Resultado de búsqueda:", buscado)

		# Actualizar el Treeview
		self.actualizacion_tree()
		self.eliminar_contenido_casillas()
		# Insertar el resultado en las tablas (si hay un resultado)
		if buscado:
			self.insercionEnTablas(buscado)
		pass
	
	def function_modificar_boton(self):
		print("\n Modificando y actualizando el registro ... ")
		# Obtener el ID del registro a modificar
		determinar_id_sql = self.posicion_registro
		
		try:
			# Obtener todos los registros
			respuesta_para_identificacion = self.comunicacion("SELECT * FROM promociones")
			# Obtener el registro específico usando la posición del registro
			registro_a_modificar = respuesta_para_identificacion[determinar_id_sql - 1]
			# Obtener el ID del registro específico
			id_registro = registro_a_modificar[0]  # Suponiendo que el ID está en la primera columna

			# Actualizar el registro
			estado_texto = self.estado_promociones_text.get("1.0", "end-1c").lower()  # Convertir a minúsculas el estado
			if estado_texto not in ("i", "a", "activo", "inactivo"):
				self.ventana_emergente("- La casilla estado solo puede admitir estos argumentos: \n 'i', 'a', 'activo', 'inactivo' sin las comillas \n - Revisa si has ingresado datos validos en las casillas de entrada ")
			else: 
				estado_actualizado = "i" if estado_texto == "inactivo" else "a"  # Convertir "inactivo" a "i", de lo contrario, "a"
				# Obtener los valores de precio y cantidad
				precio = self.precio_promociones_text.get("1.0", "end-1c").strip()
				cantidad = self.cantidad_promociones_text.get("1.0", "end-1c").strip()
				# Verificar que los campos precio y cantidad no estén vacíos
				if precio and cantidad:
					self.comunicacion(f"UPDATE promociones SET nombre_promociones = '{self.nombre_promociones_text.get('1.0','end-1c')}', descripcion = '{self.descripcion_promociones_text.get('1.0','end-1c')}', estado = '{estado_actualizado}', precio = {precio}, cantidad = {cantidad} WHERE id_promociones = {id_registro}")
					print("Registro modificado exitosamente.")
				else:
					self.ventana_emergente("Los campos precio y cantidad no pueden estar vacíos")
		except Exception as e:
			self.ventana_emergente(" Ocurrió un error al modificar el registro: \n\n - Asegurate de haber hecho click sobre un registro ")
			print("Error: ", e)

		self.actualizacion_tree()
		self.function_mostrar_boton()
		self.eliminar_contenido_casillas()


	def ventana_emergente(self, mensaje):
		mb.showinfo("Alerta", mensaje)
		"""
		# Crear la ventana de error
		ventana_error = ctk.CTkToplevel()
		ventana_error.title("Error")
		
		# Deshabilitar la interacción con la ventana principal
		ventana_error.grab_set()

		# Crear una etiqueta para mostrar el mensaje de error
		etiqueta_error = ctk.CTkLabel(ventana_error, text=mensaje, font=("Arial", 12), pady=10)
		etiqueta_error.pack(padx=(20, 20), pady=(20, 20))
		
		# Botón para cerrar la ventana de error
		boton_cerrar = ctk.CTkButton(ventana_error, text="Cerrar", command=ventana_error.destroy)
		boton_cerrar.pack(pady=30)
		
		# Establecer el foco en el botón de cerrar
		boton_cerrar.focus_set()
		"""

def exit(event):
	sys.exit()

def reinicio(event):
	print("\n Recargando ventana ... ")
	python = sys.executable # declaro de una instancia 
	os.execl(python, python, *sys.argv) # funcion de systema que reinicia el programa

if __name__ == '__main__':
	dataConfig = configuraciones()
	root = ctk.CTk()
	#root = tk.Tk()
	MainApp(root, dataConfig).pack()
	root.bind("<Escape>",exit)
	root.bind("<F5>", reinicio)
	root.iconbitmap("cliente.ico")
	root.mainloop()

