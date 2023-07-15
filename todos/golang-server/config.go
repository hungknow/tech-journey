package main

import "github.com/spf13/viper"

type Config struct {
	RestPort int
}

func LoadServerConfig() (config Config, err error) {
	viper.AddConfigPath("./config")
	viper.AddConfigPath("../config")

	viper.SetConfigName("serverconfig")
	viper.SetConfigType("yaml")
	err = viper.ReadInConfig()
	if err != nil {
		return
	}
	err = viper.Unmarshal(&config)
	return
}
