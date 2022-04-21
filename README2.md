# Jtop

## Install
0. Install pip3 (use `pip3` to check if there is pip3)

    ```
    sudo apt-get install python3-pip
    ```

1. Install relative  environmental packages, run

   ```
   sudo apt-get install git cmake python3-dev libhdf5-serial-dev hdf5-tools libatlas-base-dev gfortran
   ```

2. Install jtop by pip3 

   ```
   pip3 install --upgrade pip
   sudo -H pip3 install -U jetson-stats
   sudo systemctl restart jetson_stats.service
   ```

3. run to start jtop 

   ```
   sudo jtop
   ```

   then press `4` and `s` to enable  memory swap  
   press `q` to quit
