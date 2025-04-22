package com.cognix.model;

import java.util.Date;

public class User {
  private int    id;
  private String username;
  private String password;
  private String email;
  private String role;
  private String profilePicture;
  private String about;
  private String name;
  private Date   dob;
  private Date   createdAt;
  private Date   lastLogin;
  private int    cartId;

  public int getId()                    { return id; }
  public void setId(int id)             { this.id = id; }

  public String getUsername()           { return username; }
  public void setUsername(String u)     { this.username = u; }

  public String getPassword()           { return password; }
  public void setPassword(String p)     { this.password = p; }

  public String getEmail()              { return email; }
  public void setEmail(String e)        { this.email = e; }

  public String getRole()               { return role; }
  public void setRole(String r)         { this.role = r; }

  public String getProfilePicture()     { return profilePicture; }
  public void setProfilePicture(String p){ this.profilePicture = p; }

  public String getAbout()              { return about; }
  public void setAbout(String a)        { this.about = a; }

  public String getName()               { return name; }
  public void setName(String n)         { this.name = n; }

  public Date getDob()                  { return dob; }
  public void setDob(Date d)            { this.dob = d; }

  public Date getCreatedAt()            { return createdAt; }
  public void setCreatedAt(Date c)      { this.createdAt = c; }

  public Date getLastLogin()            { return lastLogin; }
  public void setLastLogin(Date l)      { this.lastLogin = l; }

  public int getCartId()                { return cartId; }
  public void setCartId(int c)          { this.cartId = c; }
}
