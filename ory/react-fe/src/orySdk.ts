import { Configuration, FrontendApi } from "@ory/client";
import React, { useCallback } from "react";
import { AxiosError } from "axios";
import { useNavigate } from "react-router-dom";

export const oryClient = new FrontendApi(new Configuration({
    basePath: process.env.REACT_APP_ORY_URL,
    baseOptions: {
        withCredentials: true,
      },
}));

export const useOrySdk = (
   getFlow: ((flowId: string) => Promise<void | AxiosError>) | undefined,
   setFlow: React.Dispatch<React.SetStateAction<any>> | undefined,
   defaultNav: string | undefined,
   fatalToDash = false,
) => {
  const navigate = useNavigate();
  return useCallback(
    (error: AxiosError): Promise<AxiosError | void> => {
      const responseData = error.response?.data || {};
      switch (error.response?.status) {
        case 400: {
          break
        }
        case 401: {
          break
        }
        case 403: {
          break
        }
        case 404: {
          break;
        }
        case 410: {
          break;
        }
        case 422: {
          break;
        }
      }

      // error.response?.data?.ui.messages.forEach((message) => {
      //   console.log(message)
      // })

      console.error(error);

      throw error;
    }
  , [getFlow, navigate]);
}