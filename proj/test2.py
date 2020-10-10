import tkinter as tk
from sup import retrieve_sup_result
from adc import retrieve_adc_result
from jg import retrieve_jg_result
from mid import retrieve_mid_result
from top import retrieve_top_result

class SampleApp(tk.Tk):
    def __init__(self, *args, **kwargs):
        tk.Tk.__init__(self, *args, **kwargs)

        container = tk.Frame(self)
        container.pack(side="top", fill="both", expand=True)
        container.grid_rowconfigure(0, weight=1)
        container.grid_columnconfigure(0, weight=1)

        self.frames = {}

        for F in (StartPage, best_adc, best_jg, best_mid, best_sup, best_top):
            page_name = F.__name__
            frame = F(parent=container, controller=self)
            self.frames[page_name] = frame
            frame.grid(row=0, column=0, sticky="nsew")

        self.show_frame("StartPage")

    def show_frame(self, page_name):
        for frame in self.frames.values():
            frame.grid_remove()
        frame = self.frames[page_name]
        frame.grid()


class StartPage(tk.Frame):

    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        self.controller = controller

        label = tk.Label(self, text="Escolhedor de Champ", font=("Helvetica", 22), fg="purple", bg="black")
        label.pack(side="top", fill="x", pady=10)

        btn_sup = tk.Button(self, text="Best sup", command=lambda: controller.show_frame("best_sup"))
        btn_sup.pack(expand=True, pady=8)
        btn_adc = tk.Button(self, text="Best adc", command=lambda: controller.show_frame("best_adc"))
        btn_adc.pack(expand=True, pady=8)
        btn_mid = tk.Button(self, text="Best mid", command=lambda: controller.show_frame("best_mid"))
        btn_mid.pack(expand=True, pady=8)
        btn_jg = tk.Button(self, text="Best jg", command=lambda: controller.show_frame("best_jg"))
        btn_jg.pack(expand=True, pady=8)
        btn_top = tk.Button(self, text="Best top", command=lambda: controller.show_frame("best_top"))
        btn_top.pack(expand=True, pady=8)

        lbl = tk.Label(self, text="SIM! esse programa é horrivelmente horroroso\nmas danese danado faz oq é pra fazer", fg="red", bg="white")
        lbl.pack()

class basic_frame(tk.Frame):
    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        self.controller = controller

    def restart(self):
        self.refresh()
        self.controller.show_frame("StartPage")

    def refresh(self):
        pass
    
def treat_champ_name(name):
    return name.lower().replace('\'', '').replace(' ', '').replace('.', '')

class best_sup(basic_frame):
    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        self.controller = controller

        tk.Label(self, text="adc inimigo =").grid(row=0, column=0, sticky="nsw")
        self.eadc = tk.Entry(self)
        self.eadc.grid(row=0, column=1, sticky="nsw")
        tk.Label(self, text="sup inimigo =").grid(row=1, column=0, sticky="nsw")
        self.esup = tk.Entry(self)
        self.esup.grid(row=1, column=1, sticky="nsw")
        tk.Label(self, text="    meu adc =").grid(row=2, column=0, sticky="nsw")
        self.madc = tk.Entry(self)
        self.madc.grid(row=2, column=1, sticky="nsw")

        restart_button = tk.Button(self, text="Voltar", command=self.restart)
        restart_button.place(x=50, y=382, width=45, height=30)
        refresh_button = tk.Button(self, text="Limpar", command=self.refresh)
        refresh_button.place(x=165, y=382, width=45, height=30)
        search_button = tk.Button(self, text="Pesquisar", command=self.search) 
        search_button.place(x=270, y=382, width=65, height=30)

        tk.Label(self, text="Lista por Winrate", fg="dark green", font=("Helvetica", 15, "bold"), bg="black", anchor=tk.CENTER).place(relx=0.5, rely=0.18, anchor=tk.CENTER, width=260, height=30)    
        self.result1 = tk.Label(self, text="\n"*25, anchor=tk.W, justify=tk.LEFT)
        self.result1.place(relx=0.42, rely=0.55, anchor=tk.CENTER, width=160, height=280)
        self.result2 = tk.Label(self, text="\n"*25, anchor=tk.W, justify=tk.LEFT)
        self.result2.place(relx=0.70, rely=0.55, anchor=tk.CENTER, width=160, height=280)

    def search(self):
        eadc = "eadc:"+treat_champ_name(self.eadc.get())
        madc = "madc:"+treat_champ_name(self.madc.get())
        esup = "esup:"+treat_champ_name(self.esup.get())
        args = [eadc, madc, esup]
        print(args)
        self.refresh()
        text = retrieve_sup_result(args).replace("\"", "").replace('{', '').replace('}', '')

        if text == '':
            text = "\n"*25
        else:
            l1 = "\n".join(text.split('\n')[:18])
            l2 = "\n".join(text.split('\n')[18:])
            l2 = l2 + ((len(l1.split('\n'))-len(l2.split('\n')))-2)*'\n'

        self.result1.configure(text=l1)
        self.result2.configure(text=l2)

    def refresh(self):
        self.eadc.delete(0, "end")
        self.eadc.focus_set()
        self.esup.delete(0, "end")
        self.esup.focus_set()
        self.madc.delete(0, "end")
        self.madc.focus_set()
        self.result1.configure(text="\n"*25, anchor=tk.W, justify=tk.LEFT)
        self.result2.configure(text="\n"*25, anchor=tk.W, justify=tk.LEFT)

class best_adc(basic_frame):
    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        self.controller = controller

        tk.Label(self, text="adc inimigo =").grid(row=0, column=0, sticky="nsw")
        self.eadc = tk.Entry(self)
        self.eadc.grid(row=0, column=1, sticky="nsw")
        tk.Label(self, text="sup inimigo =").grid(row=1, column=0, sticky="nsw")
        self.esup = tk.Entry(self)
        self.esup.grid(row=1, column=1, sticky="nsw")
        tk.Label(self, text="    meu sup =").grid(row=2, column=0, sticky="nsw")
        self.msup = tk.Entry(self)
        self.msup.grid(row=2, column=1, sticky="nsw")

        restart_button = tk.Button(self, text="Voltar", command=self.restart)
        restart_button.place(x=50, y=382, width=45, height=30)
        refresh_button = tk.Button(self, text="Limpar", command=self.refresh)
        refresh_button.place(x=165, y=382, width=45, height=30)
        search_button = tk.Button(self, text="Pesquisar", command=self.search) 
        search_button.place(x=270, y=382, width=65, height=30)

        tk.Label(self, text="Lista por Winrate", fg="dark green", font=("Helvetica", 15, "bold"), bg="black", anchor=tk.CENTER).place(relx=0.5, rely=0.18, anchor=tk.CENTER, width=260, height=30)    
        self.result1 = tk.Label(self, text="\n"*25, anchor=tk.W, justify=tk.LEFT)
        self.result1.place(relx=0.42, rely=0.55, anchor=tk.CENTER, width=160, height=280)
        self.result2 = tk.Label(self, text="\n"*25, anchor=tk.W, justify=tk.LEFT)
        self.result2.place(relx=0.70, rely=0.55, anchor=tk.CENTER, width=160, height=280)

    def search(self):
        eadc = "eadc:"+treat_champ_name(self.eadc.get())
        msup = "msup:"+treat_champ_name(self.msup.get())
        esup = "esup:"+treat_champ_name(self.esup.get())
        args = [eadc, msup, esup]
        print(args)
        self.refresh()
        text = retrieve_adc_result(args).replace("\"", "").replace('{', '').replace('}', '')

        if text == '':
            text = "\n"*25
        else:
            l1 = "\n".join(text.split('\n')[:18])
            l2 = "\n".join(text.split('\n')[18:])
            l2 = l2 + ((len(l1.split('\n'))-len(l2.split('\n')))-2)*'\n'

        self.result1.configure(text=l1)
        self.result2.configure(text=l2)

    def refresh(self):
        self.eadc.delete(0, "end")
        self.eadc.focus_set()
        self.esup.delete(0, "end")
        self.esup.focus_set()
        self.msup.delete(0, "end")
        self.msup.focus_set()
        self.result1.configure(text="\n"*25, anchor=tk.W, justify=tk.LEFT)
        self.result2.configure(text="\n"*25, anchor=tk.W, justify=tk.LEFT)

class best_mid(basic_frame):
    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        self.controller = controller

        tk.Label(self, text="mid inimigo =").grid(row=0, column=0, sticky="nswe")
        self.emid = tk.Entry(self)
        self.emid.grid(row=0, column=1, sticky="nsw")

        restart_button = tk.Button(self, text="Voltar", command=self.restart)
        restart_button.place(x=50, y=382, width=45, height=30)
        refresh_button = tk.Button(self, text="Limpar", command=self.refresh)
        refresh_button.place(x=165, y=382, width=45, height=30)
        search_button = tk.Button(self, text="Pesquisar", command=self.search) 
        search_button.place(x=270, y=382, width=65, height=30)

        tk.Label(self, text="Lista por Winrate", fg="dark green", font=("Helvetica", 15, "bold"), bg="black", anchor=tk.CENTER).place(relx=0.5, rely=0.1, anchor=tk.CENTER, width=260, height=30)    
        self.result1 = tk.Label(self, text="\n"*25, anchor=tk.W, justify=tk.LEFT)
        self.result1.place(relx=0.42, rely=0.47, anchor=tk.CENTER, width=160, height=280)
        self.result2 = tk.Label(self, text="\n"*25, anchor=tk.W, justify=tk.LEFT)
        self.result2.place(relx=0.70, rely=0.47, anchor=tk.CENTER, width=160, height=280)

    def search(self):
        emid = "emid:"+treat_champ_name(self.emid.get())
        args = [emid]
        print(args)
        self.refresh()
        text = retrieve_mid_result(args).replace("\"", "").replace('{', '').replace('}', '')

        if text == '':
            text = "\n"*25
        else:
            l1 = "\n".join(text.split('\n')[:18])
            l2 = "\n".join(text.split('\n')[18:])
            l2 = l2 + ((len(l1.split('\n'))-len(l2.split('\n')))-2)*'\n'

        self.result1.configure(text=l1)
        self.result2.configure(text=l2)

    def refresh(self):
        self.emid.delete(0, "end")
        self.emid.focus_set()
        self.result1.configure(text="\n"*25, anchor=tk.W, justify=tk.LEFT)
        self.result2.configure(text="\n"*25, anchor=tk.W, justify=tk.LEFT)

class best_jg(basic_frame):
    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        self.controller = controller

        tk.Label(self, text="jungler inimigo =").grid(row=0, column=0, sticky="nsw")
        self.ejg = tk.Entry(self)
        self.ejg.grid(row=0, column=1, sticky="nsw")

        restart_button = tk.Button(self, text="Voltar", command=self.restart)
        restart_button.place(x=50, y=382, width=45, height=30)
        refresh_button = tk.Button(self, text="Limpar", command=self.refresh)
        refresh_button.place(x=165, y=382, width=45, height=30)
        search_button = tk.Button(self, text="Pesquisar", command=self.search) 
        search_button.place(x=270, y=382, width=65, height=30)

        tk.Label(self, text="Lista por Winrate", fg="dark green", font=("Helvetica", 15, "bold"), bg="black", anchor=tk.CENTER).place(relx=0.5, rely=0.1, anchor=tk.CENTER, width=260, height=30)    
        self.result1 = tk.Label(self, text="\n"*25, anchor=tk.W, justify=tk.LEFT)
        self.result1.place(relx=0.42, rely=0.47, anchor=tk.CENTER, width=160, height=280)
        self.result2 = tk.Label(self, text="\n"*25, anchor=tk.W, justify=tk.LEFT)
        self.result2.place(relx=0.70, rely=0.47, anchor=tk.CENTER, width=160, height=280)

    def search(self):
        ejg = "ejg:"+treat_champ_name(self.ejg.get())
        args = [ejg]
        print(args)
        self.refresh()
        text = retrieve_jg_result(args).replace("\"", "").replace('{', '').replace('}', '')

        if text == '':
            text = "\n"*25
        else:
            l1 = "\n".join(text.split('\n')[:18])
            l2 = "\n".join(text.split('\n')[18:])
            l2 = l2 + ((len(l1.split('\n'))-len(l2.split('\n')))-2)*'\n'

        self.result1.configure(text=l1)
        self.result2.configure(text=l2)

    def refresh(self):
        self.ejg.delete(0, "end")
        self.ejg.focus_set()
        self.result1.configure(text="\n"*25, anchor=tk.W, justify=tk.LEFT)
        self.result2.configure(text="\n"*25, anchor=tk.W, justify=tk.LEFT)

class best_top(basic_frame):
    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        self.controller = controller

        tk.Label(self, text="top inimigo =").grid(row=0, column=0, sticky="nsw")
        self.etop = tk.Entry(self)
        self.etop.grid(row=0, column=1, sticky="nsw")

        restart_button = tk.Button(self, text="Voltar", command=self.restart)
        restart_button.place(x=50, y=382, width=45, height=30)
        refresh_button = tk.Button(self, text="Limpar", command=self.refresh)
        refresh_button.place(x=165, y=382, width=45, height=30)
        search_button = tk.Button(self, text="Pesquisar", command=self.search) 
        search_button.place(x=270, y=382, width=65, height=30)

        tk.Label(self, text="Lista por Winrate", fg="dark green", font=("Helvetica", 15, "bold"), bg="black", anchor=tk.CENTER).place(relx=0.5, rely=0.1, anchor=tk.CENTER, width=260, height=30)    
        self.result1 = tk.Label(self, text="\n"*25, anchor=tk.W, justify=tk.LEFT)
        self.result1.place(relx=0.42, rely=0.47, anchor=tk.CENTER, width=160, height=280)
        self.result2 = tk.Label(self, text="\n"*25, anchor=tk.W, justify=tk.LEFT)
        self.result2.place(relx=0.70, rely=0.47, anchor=tk.CENTER, width=160, height=280)

    def search(self):
        etop = "etop:"+treat_champ_name(self.etop.get())
        args = [etop]
        print(args)
        self.refresh()
        text = retrieve_top_result(args).replace("\"", "").replace('{', '').replace('}', '')

        if text == '':
            text = "\n"*25
        else:
            l1 = "\n".join(text.split('\n')[:18])
            l2 = "\n".join(text.split('\n')[18:])
            l2 = l2 + ((len(l1.split('\n'))-len(l2.split('\n')))-2)*'\n'

        self.result1.configure(text=l1)
        self.result2.configure(text=l2)

    def refresh(self):
        self.etop.delete(0, "end")
        self.etop.focus_set()
        self.result1.configure(text="\n"*25, anchor=tk.W, justify=tk.LEFT)
        self.result2.configure(text="\n"*25, anchor=tk.W, justify=tk.LEFT)


if __name__ == "__main__":
    app = SampleApp()
    app.resizable(0,0)
    app.geometry("380x420")
    app.mainloop()