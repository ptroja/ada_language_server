------------------------------------------------------------------------------
--                         Language Server Protocol                         --
--                                                                          --
--                     Copyright (C) 2018-2019, AdaCore                     --
--                                                                          --
-- This is free software;  you can redistribute it  and/or modify it  under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  This software is distributed in the hope  that it will be useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public --
-- License for  more details.  You should have  received  a copy of the GNU --
-- General  Public  License  distributed  with  this  software;   see  file --
-- COPYING3.  If not, go to http://www.gnu.org/licenses for a complete copy --
-- of the license.                                                          --
------------------------------------------------------------------------------
--
--  This package provides a template to create LSP notification based on
--  notification parameter type.

with Ada.Streams;

with LSP.Messages;

generic
   type Base_Message is abstract new LSP.Messages.NotificationMessage
     with private;

   type T is private;
   --  Type of notification parameter

package LSP.Generic_Notifications is
   type Notification is abstract new Base_Message with record
      params : T;
   end record;

   procedure Read
     (S : access Ada.Streams.Root_Stream_Type'Class;
      V : out Notification);

   procedure Write
     (S : access Ada.Streams.Root_Stream_Type'Class;
      V : Notification);

   for Notification'Read use Read;
   for Notification'Write use Write;
end LSP.Generic_Notifications;
